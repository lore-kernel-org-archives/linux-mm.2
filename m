Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093DCC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 21:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C14096B00AA; Tue, 11 Aug 2026 17:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4AA6B00AB; Tue, 11 Aug 2026 17:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB37F6B00B0; Tue, 11 Aug 2026 17:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC266B00AA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:14:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F23A980210
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:14:32 +0000 (UTC)
X-FDA: 85090242384.21.CA39777
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6E9D71A000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:14:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mCLPDBWm;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786482870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJYVKc4vqFpGY2GyZOX5iayxai8wJ3bqqyeqPSJxzvI=;
	b=jnEtzUXb5+15Z+IQoPG8hFLK9hnrM+4qHzKTzhAPZtoJPH3Wt3cbchxIk5l2gBvrQIZkhk
	/wrUNZQH+9wA8fknNKz3ZXBWMHOv35LsJbbDXumNqioBlD9JEH2YgZ7DrwfpzoDvaktfYb
	6/HIwAPxiujdbyC924/ZMKvv2bTnLss=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mCLPDBWm;
	spf=none (imf19.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786482870;
	b=h4Ca7vC2THZUmQJ3INNT8cOQjUwckF0yw9Oo8WCSccCDCDcHlozRwKjJa2mXZ/RyRSIwpK
	nH58oT67wRBNk1/Nw8+ChOf5I5xw6GNy0DKB+pKUbvY/rqpWD1n6Vp4t6VwhuIQsXL1JsZ
	K5fZabtJd1RQNkkDd5dLf2uC8Bvviwc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GJYVKc4vqFpGY2GyZOX5iayxai8wJ3bqqyeqPSJxzvI=; b=mCLPDBWmADvLXBLPtDhC+cOaCt
	7ws1QwQlnSnP7zWVQwfSlHZYXfaXlKkqVdvrCpK1MUpfQIOYKTE6J8AQXOZP4yW7/DtBmgenGZMkp
	QF88oLkDYUvREyG/bmCM0vWfg30Z7WW6AwwWM4HbM9JZ0RIDH/8AITZiEUJzC+mRJ3Sn6RCCc+DDS
	dJkO0oWpNm+X5vHG1MXt1upDL6R2VSdJ1QE8kPfQa7HfAk1IjlaJFIhDNC+wNNyc5a9CcTclMH8ZH
	i3oXuuZDDEzDdut/joMiRGAdxdsXd17kTJPEFHJbJLLb7RXOcGXgv7lc7lh3uu4N9v5p8IZ0WaugZ
	Cn7JuRbg==;
Received: from [2001:8b0:10b:5:e09:5b1f:c111:693d] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wttnj-000000010lM-2H7N;
	Tue, 11 Aug 2026 21:14:23 +0000
Message-ID: <27f2326dc66d6341174c0e510aa518a1297b66ae.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, akpm@linux-foundation.org,
 david@kernel.org, 	mhocko@suse.com, rostedt@goodmis.org,
 bigeasy@linutronix.de, 	simona.vetter@ffwll.ch, jglisse@redhat.com,
 christian.koenig@amd.com, 	paulmck@kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 22:14:17 +0100
In-Reply-To: <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
References: <20260811162423.GL544626@ziepe.ca>
	 <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
	 <20260811172627.GN544626@ziepe.ca>
	 <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
	 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
	 <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-TbVLQf1nSIoSFSmwNNnR"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E9D71A000C
X-Stat-Signature: mntijx37k1r5spb4pxyhwgbisregmu3k
X-Rspam-User: 
X-HE-Tag: 1786482870-223321
X-HE-Meta: U2FsdGVkX19G6o9788ikKg6y3OjZvB6VXPGz3TDzgmlUdc8JQ3KIJglFlPTXauQPViLlBJx5FFFjmIcTXIUis21dGjx8jeW6ek7LoPcxo2aqxUeG5bdiKyTiTKwaZOnPIijnVe6gyyHKyGx6LlTWUtrlJiswM4O4t9SNZM3LOCedlL5mTHnDbXyFlw/0mQDGfLnT1cyES8pblxRrMgB8PsOX4odrxZCq87ZQWiAP68sj7efmpx/ZavyRUTG3+ko1a32yoxOj8EsW4mHDF9G8Qee2dOCUjDf9MzgXYURoZ2YuksNrAzV76tGNgKIOs6eNQ3rZ2Lpvwm3ErTlxhkub0LMIdeaUo22OH5/ivCLkcVU9XlIapbf8WFNRTTXuHcRJRX5zbZQ2MQy+MQwD2XlcuySMJ4BYrPDH6Ect+nTgOk8iK0G89c11PQQnbOIrZU8knWzTOWDWIeBe75TztXVTaNCHROeNA9ua0fVBhPGSbcjvrk9cWRNBrrMp8/juHmvPE4hBGWnMZ5HSxXC+SDMulMgxz5w16oHY/6sTqVSgadEisM5oKcIo1UG11txzI+W54bYdC3bJi4h4cU0AtjyUeGEDatgq14UitvQ8xqSMYkJCpSr3ySVnjWXM7Ob5OrNkcA4a5dINydP2//W6nxnyeU/eukGkPNmr7W2RfZh4qyK0QtXylL+qz7Enuy4E9XGU562EAdWVfhFp9+AFlhzAA7HkcVz8y19f6Cqug3JGk0P1AHhDwZvgOgCYujseXoK+R4LMmCeMrd5ugYWrtEPbmJePqi52hrVdbrIarGUayYrHE0uh/9lOTvRdQut5OoHPLpXhKBk7NLVz1NOUxE/35hQpVe37dfaD5KfpJDoWioUbzglJ7fLI9eYZ1p74fQaQfI90ycgtvabENhqYuDU0s3PayS92Tol4a6QHT4bvwX6EEXnuBq8oM90wlleSiZWrc2N9joHoDEZBb7qqS+A
 pED+5ILr
 /j7w0bg8+lz8J7ierFeJe0wS+SGA9xkmHP0PPiyulpPcyytWtsdgHorYrKvXPbhRlgIOpOftXRE+gyHp1eBMGyKbm++7J7ZbSX7aumGuleT9RPhrK9eazzfDgklN6YfVkXLRjS3JoMqPSoaxOkGG3Syhf2XNQ4ER0eVwpDcDUl5jzoUOX2y7BCJKysKNXm6bSJedPn+lMtGk43GyEFUVFrqg8uJXC4IimFt1f1/A/0whmoVmcJGOz6FFv/zLw/dRVpTRuz4BjeUIlkzQTuGmVI8W8EqN5lG7hmdxlXTjNfgY+YBhbLIS0W28RS7mfLLIzbeNVFhdSP9SXw66ZmolDF9JDsCRE5B40HmIsKedIfRj2P8uDJJjJD+d6gK6pssbjb/eB8a9yajovsBlGBUOAVdYid+6Lh35C9GUddiewK+26xAJgxCyDb3iIrAucsZnmilVM0pEDnhLOP8CkemA3cDQpTDYJb6PEl5z5+We0CgvRSVOXBfqemG05kKQ0FpSwubZqc2dlM89K1PtmV6faA33NtWLp71AlFctvjLSWuPPp+yPVqAd3YyV1j97RPnXDq0KFWWfwEbUuCMNsKBQM5UbMXD+k5cJsPCZ73S684+zDzlvDZfk8EmJgCOrq4qkjXUnnCo6I9h57dPBhGffotO8ZNG4aBMArab7Ppo7CKfZva+/oljcORIuI+aaJvFryjA/zLPmG8cMsyN47xlv49RhlEo1fE5NSnDPKtr088UlUPMnGvsZBJ9WQeXrJ09WQ+9iQnZbobrSyuadgMvZHyizeDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-TbVLQf1nSIoSFSmwNNnR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 22:21 +0200, Paolo Bonzini wrote:
>=20
> for_each_present_cpu(cpu)
> =C2=A0=C2=A0=C2=A0 if (per_cpu(kvm_gpc_reader, cpu) =3D=3D gpc)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask_set_cpu(cpu, gpc_reade=
rs);
> __kvm_kick_many_cpus(cpus, wait);


I'm literally sitting here watching you reinvent what SRCU already
does.

Which, again, is *fine* given the behaviour of *these* read-side
sections.

> Alternatively, there's always the poor-man RCU using an rwlock_t; you
> do read_lock/read_unlock as usual for begin/end of reads, while the
> write side does
>=20
> =C2=A0=C2=A0 write_lock(&kvm->gpc_readers);
> =C2=A0=C2=A0 write_unlock(&kvm->gpc_readers);
>=20
> in place of synchronize_src().

And now we've come full circle to the rwlock we already *have* =E2=80=94 bu=
t
which is back to a shared cache line for readers, and which RT turns
into a sleeping lock, which is what I started out trying to fix in the
first place.

I get it. RCU is a versatile tool, and in *some* cases the *Sleepable*
variant of RCU gets used in ways which would cause grace period
latencies which are thoroughly unacceptable in an MMU notifier
callback.

But in the specific case of a dedicated kvm->gpc_srcu whose only
readers are tiny snippets of code that until today were always run with
rwlock_irqsave? That is *not* Jason's worst-case bugbear. It's fine.

--=-TbVLQf1nSIoSFSmwNNnR
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
XP/YFFWeFcqoD/OEHoejP5kAAAAAAAA=


--=-TbVLQf1nSIoSFSmwNNnR--

