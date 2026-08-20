Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83A7C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B6F6B00A0; Thu, 20 Aug 2026 10:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4406B00A1; Thu, 20 Aug 2026 10:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74EC6B00A2; Thu, 20 Aug 2026 10:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 843966B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:27:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20A29401A8
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:27:05 +0000 (UTC)
X-FDA: 85121874810.11.0C7DC5B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 481334000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:27:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rc2mDGGm;
	spf=none (imf07.hostedemail.com: domain of BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787236023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5mAyoRZ1DeCCNtOFnYZquL7XbFPczim4+hkLsgLhzAc=;
	b=T7KWOqjJjlch16S1NhGad2dQb9NKSx6xcIjYj7cgWy/0dqdA6IOD2A9hgp9ZQ8qU1TlLn2
	79J9EasVJrum/YAOk6C8g+VaoMw0Z1WGMS8KsShrZWdqOUMjsGtAOuta7Nfg7WEXQPIn4x
	cXtuT1G8P0HeLVtycskkcx0vGQlbJJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787236023;
	b=OcDizbuwjyYhSN3TJI6Qa45E7JlTESf8FmuLtoHVTVR8gSP7WtfWlxLfJoiccDUuuzQZvV
	F0U3VhFAKF0eUTAeBHDWRpuTjrMVa/AqBh6IMRXPbVcfDh86RqEVHUY3j4b9umvZPpFWud
	IVzFt/Ynj5+YPBWIZ8OkmvbBjSing2Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rc2mDGGm;
	spf=none (imf07.hostedemail.com: domain of BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+79dde780bc9caf9b17d7+8397+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:In-Reply-To:
	Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=5mAyoRZ1DeCCNtOFnYZquL7XbFPczim4+hkLsgLhzAc=; b=rc2mDGGm3RTIKEcp3fILb6LLOn
	nt3XhSHTTNO7Kc8ryHKyeVpNJrPQaQ0vZSCpOWg7vvTihpCySjU8Pr/JrVL7LUPAebdGgyx8xW+wz
	IDSKlkyDgvjM13s0BSXkFo/QBMo2Bic7A3f+pKDfMnv5kFVD40Gdz7NeNB1f0+7HWQ0LR9g1lsnec
	D15W+nHvnqhAlmG7i4BiLaiLGHCB0k8xV7KFBqIaqkElJr56UJmPy5US/OeYguzMfMP8/mASk/sxf
	/7c/M3x0WAhtKpj6WhcovgyBcBGAwCzb0uBCiGyEjLgCJaA12rB73MaobiqFPq3gxPrBJFLhuYlnY
	VYDrsOzw==;
Received: from [2001:8b0:10b:5:606e:77cd:9db3:6c5c] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx3jD-0000000Fns7-45VX;
	Thu, 20 Aug 2026 14:26:48 +0000
Message-ID: <448c5c0128b08ab98d175ae1099ff4d4874e49b3.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton	 <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter	 <simona.vetter@ffwll.ch>, Jerome
 Glisse <jglisse@redhat.com>, Christian Koenig	 <christian.koenig@amd.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Sean Christopherson
 <seanjc@google.com>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, 	linux-kernel@vger.kernel.org
Date: Thu, 20 Aug 2026 15:26:35 +0100
In-Reply-To: <20260820133020.7ZCRIhwX@linutronix.de>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-HaviD9OcfWUIvdKhLY5P"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: ait8behefdhs9zooqtxmh8pzzruq5ojm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 481334000B
X-HE-Tag: 1787236022-118738
X-HE-Meta: U2FsdGVkX19968iXnryK4/wrnxrDZx3gWQkPGs4ALz2In1CBCJN2WMSOTAZ0NL6zUt+E2cukuNVqT6iOujlzLUBzkReArUkQm921dgUNE0tRVeNYwg8gNZ0/V5DQbojMl3/tD5/YSeAB0ryVvmdZZohXU7BNuFYEBOnsmLH4HQSGMOdYOwZpj0wh7JrzjWqXrPbLQ5gAXVgLFnuEo+yhpWTj6LLqMLVwI87f8yB0FVOqzbh5w5GlcHo4iN5TE5MbEsjAKSSEptYYEcmhQ0igfpQCuy01h3fKncDLqSJLIDSu4zJblmF9cyWFxaC2abuaVHJaQ1roCgjBXMqUtLbIlsle9b//c46uKXlKaUxe0mUSdowKSjydvCWJt/m0Y6rpDeG6dDQzNap/adFySOGAoSPa65L+FKAC+l8KbjZAhHQ0gw7SdQ/ir9EBS+HKc4UlSL6Z4JPxFllIQqlIjyjHOuI+Uu2WVYJ3kVKKmQXs9ARlZlV+KMkyc/D7Lv7iSuv10zPdewyQ8JrRciEoeb39EibMAdGqrDmHdwARZnWoH3+I464zM/RG79RoDiwi9kofIWVMQ1CtCmIs9497/3KIwzU1zI4l2Mn9lrsQcJV0mRH/D7U0uL6QRR43nXdEzRi9zGXgJtggO6Z12cnmxT91PXjBQpdLd22h0YO5CZeguRYJVzbOUdFlYgIfyYFh6g0inz0n82akEQhiP1d3RkM3n3Sy+hV/7gSOy+gfkgPkl5HxskakOKcTjwks3OBIjrZMP8wzeyo5K2sdc6g5kA0zLTQ6lhNGwamOQI2zKrMkH63WafNcD9+MeQ4mLWOHM987su0X1gTDG7qAxqLqqWBn8rxdOb7QzJTHG/3aVuklg0U7bRIBzhNrCJxwE3H2goy/8E8fZrEpT76hOs5spyOld6g3PX3tMVO74FJ6J+G/XqpSu8uKd5y9o9rDxJZl2t/JTdnfSIwxI10h/X/oEcB
 9p4sr4vX
 gGn3ZCRSTrFMqds+91rUWksG3TAGbaPFAqPeycJnBEhMo1p6XPpCu2OzVvRd9PUGz5z6LBHO7VIYpwYclDvaPmDBP+TAPyNILpOaY4gwHAow5ruAuKB+mnvHNkC5ktp60mYGTpkR/uLjS3YJ+aK35N24r0LZE/1npKLOlZZBDH5FbrLVOuPqQOs0O0LbaJwVGHuPfuOrC6vkpHrbBuo6L5Ai+hXE2S2pbLQtK81ltNh9AqSv02RiEdxNSk0bptQ3e2RltlpOcGq1lyMDS64Ysd/zpFqalsv3GSmhtO/zuugsvNixmiyC3Q2DelgZvSow9N3ez9+3IhYk1ctw6sTB6Gy+KJRepVPBS86HlDB8tq0V8/Uu8FV9DvuIS3I4Ah1fwkxhq+7jMDto7gvQNwP/w1P4cHokwnBBNi1fM08JOOOyEhyQpys6UtzF/TO3e5EpK8zK6+qY3g6IowdWX0wlLqsJHctLmTe2LdFEPEAlc0Rajk6RSfD9vqbmqurxCESf+62BkAGQx7bQpYmFLENOineR6FSeudn4L8LCOcvvTCgcAHNQk/olwzlp7iXUrWYtk6EyoL0Maz7QVtG8e8QDqTGqFGOSB2/nFXGpMFj/fZNlSSWDx3SgIodXAju7+HqHbrwvNg3PRJmH75xhc/Mf9313/wGbluzj+Y9USRFfPcekSssqTgDtDzMrZp5cpaqPObi/ieZnTuMMmHlm1Qb2CyqBLBGwxxlXDLDNM4bKBnvdh/E/iqZhThAKTaR2c8flmzioFWJHoRP3lmRjKmLHMXKHVC3vRh6OtEL2xq0Vm1Lhu2/B8pmJIJRKbow2fQs6WQzpECGDhLM9SxlV+ntD7261g4UCNGgqMOEnpgKnjkB8XlZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-HaviD9OcfWUIvdKhLY5P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-20 at 15:30 +0200, Sebastian Andrzej Siewior wrote:
> So if it is *just* the annoying splat on RT, I could try to teach
> might_sleep() no to be upset here.

It *wasn't* just the splat on RT... but I think it can be reduced to
that. My full set of reasons were:

 =E2=80=A2 RT turns rwlock_t/spinlock_t into sleeping locks.
 =E2=80=A2 We believed a waiting KVM_REQ (IPI + wait for acks) would sleep;
   it actually spins with preemption disabled=C2=B9.
 =E2=80=A2 synchronize_srcu_expedited() in the invalidation path really doe=
s
   sleep on a workqueue completion, even on !RT.

If you deal with the first, the second turns out not to have been
needed, and that just leaves the third which is the SRCU atomic thing
(qv).

Aside from those selfish technical reasons, the check is actually
*wrong* because "must not sleep" isn't the real requirement here, as
discussed. And when I went looking, not only did I have to hack the
kernel to even make it trigger at all, I also couldn't find any example
of it finding anything that *wasn't* a false positive. The only
concrete thing it *did* achieve was making us strip a necessary
KVM_REQUEST_WAIT to appease it, which opened up a use-after-free.

So if you fix the might_sleep() and Paul comes through with the atomic
SRCU thing, I no longer care *much*, but still think the whole thing
deserves to die.

Going back to SRCU atomic (citing your mail in reverse order):
> In
>    https://lore.kernel.org/all/a94b75e8b9b1d2191f365c0f4275fd5082332df5.c=
amel@infradead.org
> there was a suggestion for "srcu: Add an ATOMIC reader flavor and a spinn=
ing
> synchronize_srcu_atomic()". This one had preempt_disable() in
> srcu_read_lock_atomic(). This is bad as not only forbids to acquire any
> sleeping locks (such as spinlock_t) but it also does not allow any
> scheduling of any kind within this section.

That was kind of the point :)=C2=A0

My=C2=A0srcu_read_lock_atomic/synchronize_srcu_atomic() were born of the
"need" to avoid scheduling in OOM (RT or no), but actually I think they
survive even when that requirement goes away.=C2=A0Even with my
try_synchronize_srcu() optimisation, we saw higher tail latencies when
deferring to the workqueue, and Sean was very much in favour of
eliminating those.

So I think we do want synchronize_srcu_atomic() if Paul can find a way
to give us that.

To your point about preempt_disable() in srcu_read_lock_atomic() on the
read side... I don't know if we *need* it to be like that. When I threw
it together, I was thinking of it as a raw_spinlock, in the "must not
sleep" mindset.

In fact, as long as the splats are dealt with, it would probably be OK
for it to be equivalent to a non-raw spinlock: disable preemption on
non-RT, but not on RT. I think that's perfectly OK for us from the KVM
point of view. But does heavily depend on how Paul wants to implement
it, of course.


=C2=B9 I wonder if we might want to change that on RT?

--=-HaviD9OcfWUIvdKhLY5P
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
GpFLqSOt1i29IUXHTXYpoEYAAAAAAAA=


--=-HaviD9OcfWUIvdKhLY5P--

