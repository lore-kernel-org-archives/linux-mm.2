Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9E2C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85BB6B008A; Tue, 11 Aug 2026 16:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DF96B0092; Tue, 11 Aug 2026 16:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AEF6B0095; Tue, 11 Aug 2026 16:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B066F6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:30:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 411281C05EC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:30:09 +0000 (UTC)
X-FDA: 85090130538.29.9DA140A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3694A0016
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:30:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8D0WZHr;
	spf=none (imf15.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480207;
	b=gsCEWmhSynIoD9BsGTnCTX/zsvbILCQS53PP0q0Nn6EnEb/c9y8T4HB639VA1Z1TZKwYTi
	YrRvAqS8GcSEYOF8bRlfj+RMbGi0KU+2CsTDh4RFaK9FktpFpY16ixyYBcHNdR85Dha6nV
	2dmTWg6JfunwEbw1n+/QNAXszR0tDwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8D0WZHr;
	spf=none (imf15.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgGbykudFHIttje2K2rWjbkBicrY1aEq9u/MZjdSFj4=;
	b=cQ5Tk3DSaT0hq89kMyky98j8vXe6Lxgo0TVeU1RLDdtXANpNL52UfcKRa6bKa+NMDi+oD7
	6tghsh/SW/MzvpQnvV0dO6nmu6vervNhM3pIRHrvR6SRVkgn+MhOOJ75/1xvbxEVDbQoXu
	AHlfacm21waYjnLsaQVuezvVqTrrbC8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xgGbykudFHIttje2K2rWjbkBicrY1aEq9u/MZjdSFj4=; b=d8D0WZHrUfGdECrNxhXTO0Phna
	ZNRI5A63MYO4bxZbZjulxr5l9ERs4A/e7QardST9l49mTfSh7SdbRnSPyUm/RwDqxosxyMQ7ySnkh
	xaGLQPF58yRSXtnw7CRQUoELR28q85zh8ks0Ec/AWIsHh8GBhOotNsEwKNQhD7Rpx26zjLoT+2qPP
	PXz/7uPnrHy2VYVTeNRkcK1AFJshUkLdPd/mrE4Oq8ZW8gG8Ui1xHXqE+1bNagQIZCweY76cmcxx4
	T+dpU0mnOV78n6sYm89NEfSPUnGqxP3/Q+NGGWVT1VoxVQ1RVzOsQL7pnysINhbv0aK+324Tr5hpo
	Q/TK+a3A==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtt6j-00000000y8U-0rXF;
	Tue, 11 Aug 2026 20:29:58 +0000
Message-ID: <5212728e97749b29bc1815d349e7e2b11d023257.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com, 
	rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch, 
	jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org, 
	pbonzini@redhat.com, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 21:29:51 +0100
In-Reply-To: <anuAq2s4mtyw4_Ql@google.com>
References: <20260811162423.GL544626@ziepe.ca>
	 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
	 <20260811172627.GN544626@ziepe.ca>
	 <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
	 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-85SRVXFNik7CKKJwkqMg"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: F3694A0016
X-Rspam-User: 
X-Stat-Signature: 6x39j81dqhn3dhwg3r1i7t6huoz3fzyw
X-Rspamd-Server: rspam06
X-HE-Tag: 1786480206-512652
X-HE-Meta: U2FsdGVkX194ZgdhaYIZ5WbDC5Bs4eYJKxlWlvfTVyVqBE8IHhO9XFgNyDS/nvPQBrbB6u+4adwSRW62f1+EKgIiqoLOSv0lup1y+Th5LMHhihGLx/e/kmPqT7lUYKZjqw3nPLniT5n9yXg7zA1BmDL+1tiQJ01UUkUmTFGLOWD+gibom8GgwQ4mYpkDVjQTdy1DpbU3bo6ZTrZ20QjvlCIKWnaxvhAcrEvx09pfIM81kC9RZR4zENi8FXTLM5tOvn3CJPOf3FsCoj1Cnj9QgUiFFek8aKYJbpiEeO6y3b4TQxurz1Gi9agiy4kRtuus5uMoICcUElz5tsBuM+YtVWDSGjXTqZNZUmNGLoU++j9fXgPmOaypmRfDbp/JZEwGBiWpgX1Kq9ciQPbJNPFAQI8/DV1VVIMEgDZEp0Iz2+IYhIefl+PhbK7wnfGSikjB1FNqhqL4Wnj/ex6phFvt+ddluEQN4ckRbZ5SaBNMmcPeI2/RXL8KsERFPuo8fNe6g8sC8fd+8ChRUskoNu2P4y3aRhFPKp4IQ02RhK9AQkg7R35v82gFFyo6j1kqlCVIXAJNGu3c73YVRz8NojWAhF7XugmZlQBVleqTJ/vFu2X+l0rHBg2wPsrEcLaLtXzdlvvaNNuKWjTkmRKboEOSy50hy80FaJPO92ZiDGiBlb3G+FvtOjgOPuEsdaIC0w8OYXhKY2pUVBYgOloXLLdS/FzgrUQXDgOkdPrg0teOR90Optbjfq84dEdBuobkONINR6j0Enz+nZy9LvlGU6MQTtTj4fgAraTIHAxBB5MUkaku+K994DsR0kjHJT32fhy6v1lz4AZXGv5tbmA7uPG5shq3pp1db5XKq+1tQdurF0FUNb+fEc0glNbv40fDYvGvgaW3njth6Hcv0QhRiRSUMclXyAHNwRs81XmW8zo1PUcgp3QwmhGNbP9lGyLKMwMJTJXvuVGirkvl/yaN0KR
 qWKg4bAW
 8+b26Z5M2k7XM767mHD5ivnGCRt3eyPYeXUxWzJ3EWtBSQrIm7cvKYBRTXAv8seFyABmfzBbsyfyQ/H40yEkLBG5hF51yfRaWZjqNWYXNwDdbt7EjhXI31fhMIiFm6RnbouziaeR38x/S4d9qkx4JeL8s+7sOlfQeMyT1BdLzNBc8E2kYqceZ10vrwwjhyoZkG/eC8JlIPF0HY3GknUYx6G3AH2QjteLMfwQrvGR8q/5TU++gu7HVRS9tLCHA1x9e4y+OrBoBEMO3Yb+fRzouRdxZHchEGsJwBdRAbZdrcfghclX6xtcdTAB4VRpSJVuvgZgdPs+FzuQnFZwvV8smmhajJihZ8nxd/Yb/ug3PFZ4YM4XzCe9sLwzu0cR3As7QuMK//hxS+5XcpRyGygp5RDpIR484bABNi/QTNptB4ANFXwBizm1nz65HOaSkxVZkbck1srbDxzeQrm2kGVe/M6uohRbLooU0UVGmsSVVRyqb0OSymIDfrGARrGadi1MA7qcEBP2qtBTPrLL/vHDzqH73KEl9pzjllrFMuQK5r8FsRn8hj3Zoo1Q71L9tgTrXWUoYLA1Z686ksebjDPJL3s3jg2W8f1UkIKMW/qZuEiFmgR1qYo6YnMr1pzUQtG+xWcshccO19mrwBvO0MOxvCTqPZ9m9u8b+9uWwNcsXdAi0Na045swNDFefqWmkgSacat6aMQ5g8OrtYsw5NmyDSVwaUgOcdp5VxL/1FFsV7OH2ZAWNtdfiImFBj+JZCl+f4RHcsFjbxqGtb+R5U4pjlmlSTQjtWbQoaSWeQboCgz1VxBC9kKHyOxQoEwmShao9OcgfRvl39iGhCYt+9CbjUmgQqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-85SRVXFNik7CKKJwkqMg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 13:06 -0700, Sean Christopherson wrote:
>=20
> +static inline unsigned long kvm_gpc_read_begin(struct kvm *kvm)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	cpumask_set_cpu(smp_processor_id(), kvm->gpc_readers);
> +}
> +
> +static inline void kvm_gpc_read_end(struct kvm *kvm, unsigned long flags=
)
> +{
> +	cpumask_clear_cpu(smp_processor_id(), kvm->gpc_readers);
> +	local_irq_restore(flags);
> +}
> +

Nah, those are all on the same cache line. SRCU doesn't do that, does it?
You end up basically reinventing SRCU.

I'm OK with having a special helper for kvm_gpc_read_begin/end. I was
actually tempted to do that as patch 1 in the series which converted to
RCU =E2=80=94 it's then an implementation detail whether it's rwlock, spinl=
ock,
rwlock-except-on-RT-which-gets-raw-spinlock, SRCU or whatever.

If we use the helper and still make it use SRCU, we can still impose
some of the invariants which make it actually *OK* to use SRCU because
we know we'll never hit those worst-case latencies that Jason is
worried about =E2=80=94 like adding non_block_start()/non_block_end() in th=
e
helpers to ensure that we keep the atomic semantics within the locks,
that rwlocks always previously enforced, etc.

It isn't *strictly* non_block_start/end because because we invoke it in
hardirq context, of course. We'd have to work that detail out. Maybe it
*is* local_irq_save(); not because it's strictly necessary to do so but
just because it comes with the desired sanity-checks.

But either way, the point is that whether you reinvent SRCU or not, it
all works purely because we know about the behaviour of the read-side
users.

--=-85SRVXFNik7CKKJwkqMg
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
z1dDOzCcZt6biUeC2DrX8LgAAAAAAAA=


--=-85SRVXFNik7CKKJwkqMg--

