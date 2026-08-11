Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0792C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6FE6B00A6; Tue, 11 Aug 2026 13:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011836B00A7; Tue, 11 Aug 2026 13:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5206B00A9; Tue, 11 Aug 2026 13:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A97C06B00A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E20A12F7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:28 +0000 (UTC)
X-FDA: 85089657576.12.8FD2D73
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id A162240005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lxtb5E6f;
	spf=none (imf01.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=B4A7wsoyClOPAXnWX7gglBA8XKkMwmFWASY4ut8eHZU=;
	b=FYnhCCoFP9YfELoDyc+opSxIDukH/mFCcjA4ngD1lxMWNXlpMv+5PSEIlHLoB8/TjmZnf4
	k6tDMNVUYUym6RK85+3h/5dkD6Ala+lTOtP7exZwezuyp4G5FisG8ljU6AIG4BImVMLgFP
	VWQ6T5OAb0zShUt5lEiHUIb+Ahz8fdI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lxtb5E6f;
	spf=none (imf01.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468946;
	b=J06fyoP+I4mWiCWl28NyHW0x0T+7EVnxR++s8VyVY0nhRCprE82Dx2vPLKGRpGltOjpMJi
	3+CzECEmoecGrX+P/XxXD60CTQB8XGsdN5eFb3MjysTaJf9s01edPhHRGit+Xt15dyXEBg
	ylKPHRO35529bjI3/hXi7LVSbg4DhI8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:in-reply-to:
	Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=B4A7wsoyClOPAXnWX7gglBA8XKkMwmFWASY4ut8eHZU=; b=lxtb5E6fwv4Z0IzhGrzTvW3l9h
	1FibwgNLtrKE3cL2HAnJDmP4iG5S9H1b7aXhmaBSnS3ng2BWGahlU8v7JYkgFM/vrY0RwXD3plB+1
	XvOrq8uz7M5QRx5wQbUCW5HKaCt5VyQ+SEHgy2bgMn3Zux8DsrvkXqxxv2yAYbHlwu17X1BrgrVz2
	CRRDCKBddF24fRdk9/m9FAWWl9szEM2d8ZCLcN0eN4xHf928CV/O1uB4nfh4aJdK/ZSQU/efrLuib
	Fu4FVDnOAQftirUUZ+Qtqrura+J+9ddTERKPSnmF1tYVINPNiJc7QAprKgKVdeUIgl8Xl8UgSXvHJ
	fHN08L8A==;
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtqB8-00000000lZR-1mQH;
	Tue, 11 Aug 2026 17:22:18 +0000
Message-ID: <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: jgg@ziepe.ca
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com, 
	rostedt@goodmis.org, bigeasy@linutronix.de, simona.vetter@ffwll.ch, 
	jglisse@redhat.com, christian.koenig@amd.com, paulmck@kernel.org, 
	seanjc@google.com, pbonzini@redhat.com, linux-mm@kvack.org,
 kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 18:22:12 +0100
in-reply-to: <20260811162423.GL544626@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-iI6osTXoBuApKidM5MUS"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A162240005
X-Stat-Signature: yyqimrjqq5yggfibihmg7njzgfq8tut4
X-Rspam-User: 
X-HE-Tag: 1786468945-970568
X-HE-Meta: U2FsdGVkX19Nip+OIC1dWhlXJ47yaPWDkDA0jgUF7ScY8VecUY/QnWlYDnn1i8f4jSlsbBxit05waTLCCoWa2XruovYDOmvnGHkXmNSxNA8edMa9LjmS1PVfyPF8+CNLwTQFP05WdfcwfIZ4VTgo5tgZ2zemh/f5xHO0M4HyGfinv6IW3kFr6o1SOOEdqXCda5FI7wc0UHFAhwW6T6ZeW8+g7xWbyVB+/V91qwUYDE+/11qx9QQ9HCcf5MzPFSX2PKbPtuSUySQ3w953Ne1bYarnm3txm4QQ2gt3leZYfA+4zjV6D7NjoYR0MThIx09SHYL6FxrfWf1FEOEBL64nTU/nsWWgDhKHfexAmacWv7yv8MYhDvJ1zfm+mUpNlZmIGP6LWAcAJ+51uPgN6zOo3ZXFzQRchHNLxlPkw+Bmm9nbLM08L9RssmjzC7Sotb4KYqz9rybXMe24brCwx96uVgpdtej/lJ7mFUxX4jPFpZyLVE+tSjW9lFHTtTShBQ7Ub3+RNYACU4tidrpMlnWmda103i/Tp4QEm9bUQZwj5I3GpboTJO5q0lxWHd+1NOptjiN/I0GhApendJ+U7pmOx/X8gVIEjiqCUqGYFWzf88M7mB9Nnl7ixBkNP+tKi69/ZhDXw/P+t9ZI3yo7TrQJTa3Wtsa4KhYlpwQurfQE5X9i1rpVAYss5g49l2xpRqWrAnIGxwl0OheIQGk81U7fpAEMRX/1r4JhcRaw7XtUulJBc4/mDpI+VYo+EB8k720xtT6BP6E0inSA/4I10QMDCOQfpoU6hZ4dMC0SRBRar2LW7REUdXei0bJrFA1CknZyXJDmr4kcZq8nAEbYNsui/k1WvhZfDd4yA3+jctRvwU6mu7ZmIUeL4C4rZhbpLgiKedAlQqZi0e9dcv+UZEb32d5zy24+4PvxgaqJaEnJtkjbLwXLNoLFtMQ3cHb4pW1Xi9pA8FL7wJQYZV+q1QM
 xrS7OJSc
 MqzJULzDzEYxq6HLmBhi3ODEV7KPjoeBuCiZWekmYhQUrz+/gwA+obpf46YYO69zDIBxBcdOX+0/DY3Y7vdyGioG4DoLjO4vbWXPju4ptCRsXJANidyFMkxzXxE8sH2Hv26UoYjFfLcLQYhlHpj4v1xbdsay24Avg8ixTpt92B0isA9U4taqGROzMRutwFAD8uamRuc2OiAF/utSmpSspr3pd2cUXf+wcygP04v/St8fq3EJxjBvoPTp7Yk+WPAysdzBLeU8sg5nmvxXn5wvy7YArdbeosZEqDJVrESismsep1YtZPjF0P3p1pcdGW94dywCFuXuNjoSU3m4lXeDSOPpIUn6YmPbOfHtxG1TQrTnW17Jv6+TFS4Plp1mDdoU88302O8OjAcfZhbQYYGqKpg85O74K8jlPwnjE7hbF5uAcmbO2BkFy3gZYsTO43ADLzZOceb2jc3RLPLrC0MGMFwN94cdZTnIY4hEPn7l5fa9UILB7vJGMzyi7dJnqzrfpWuisY4v9aNvcJ7dlPdzHtWHSR0FC2CjozmjnzfUBhL4TpNBbCo0e7DS6nL9DnxXS5vEK1LmA0K7nairOmHt7ROG9eckRAQQ530yY12ZqDhog0zC4vz8bqSAmzKtnfyK8pMMWv7fzAr9yQx0Za7w/VvPnSpQuKMPS5sbPfRZvIK09f8oE5TbGoDug8PfBIMuzzjwFvFAujSvW84h8J5jI9NHQwD4DDe5cb+b2ehwu1Eb3vzXqnmRc44S5fKywT14IYahC0FjiCIPadf66I0fvyIrRnUMxN1tW3Q5clrgkuRIdrzF21XJrnmNsG61rXGAx54fafMsWo4AsnOp4RbiI7U6pRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-iI6osTXoBuApKidM5MUS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 13:24 -0300, Jason Gunthorpe wrote:
> To be clear you should not be using any synchronize_[s]rcu() primitive
> inside the invalidation callbacks. These are well known to have
> multi-second delays on loaded systems which are a completely
> inappropriate performance characteristic for these mm callbacks.
>=20
> This statement has nothing to do with deadlock.
>=20
> RCU is always a trade off, you can make the read side run really fast
> and the write side is ghastly slow. If you can't handle the slow write
> you shouldn't use RCU techniques.

The multi-second horror stories are about the *global* RCU/SRCU
domains, where the grace period has to wait out arbitrary readers all
over the kernel.

This is not that. It is a dedicated srcu_struct, private to one VM,
and its entire reader population is a handful of KVM fast paths that
until now were under irqsave rwlocks.

Each of those read-side sections is a few hundred instructions over a
single page of guest memory =E2=80=94 they never allocate, never take a loc=
k,
never sleep. The number of readers in existence at any instant is
bounded by the number of vCPUs plus a few interrupt contexts, and the
grace period is bounded by the longest of those sections.

I should actually change to synchronize_srcu_expedited() =E2=80=94 and perh=
aps
we could ponder an even more expedited mode which does the first check
directly and in the common case doesn't even *use* the workqueue =E2=80=94 =
but
even without doing that, the write side is never going to be as
"ghastly slow" as you seem to think, *even* for the tiny handful of
virtual addresses for which it even kicks in at all.

--=-iI6osTXoBuApKidM5MUS
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
lTEj9+hBV0b2VUZuGyzBmKMAAAAAAAA=


--=-iI6osTXoBuApKidM5MUS--

