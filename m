Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79168C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384486B008A; Tue, 11 Aug 2026 10:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B286B008C; Tue, 11 Aug 2026 10:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298F76B0092; Tue, 11 Aug 2026 10:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03F186B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:21:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 944051A0424
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:21:54 +0000 (UTC)
X-FDA: 85089202548.06.BA8CAC7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9FE5C000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:21:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s+M2Pbyc;
	spf=none (imf10.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786458112;
	b=KVhfTshiNzny3O95VrWy0UdwOlhCGeprK6GL7Q8rOxDa8wb8LFmB7AqOnqb51xLEsG4LZv
	BwxlCZavQYDm6ypsseRoZQodA35Css+6yzFFqYlCKdFh0/y58RXNkliM1ai722Ixhcqmds
	HZe4zcIbAnwC8b07uV2VNJHQuYRSvEA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s+M2Pbyc;
	spf=none (imf10.hostedemail.com: domain of BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+b6a5eba76e218a018a6a+8388+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786458112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJJjjATtFKU05Pbb5NWTmdcva83VXDWQi5C907CeheU=;
	b=IlvEb01qTYQvQ1FvVGCEdra+OUB/4AnTOSMEzNiQ30JpQzQBgKRtCB1BvQrDqNfWBu3rTb
	ffVx9kr/vNaFlvWit/pkaiA+0u+igiLuegb41mWbnCNqT/6X3rI5gMhrI/QCPQGORkmVH0
	loDADsqQlRBeM64JyD+Edhplbdb9cmk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nJJjjATtFKU05Pbb5NWTmdcva83VXDWQi5C907CeheU=; b=s+M2PbycDQ304xHytR4t5POCQ7
	0x3d6J81kC95rdpHfyj4kBJMW2WjG/MIjE/GIilA5bqVTewCT5wBVHUszUto6Ba6nponL2v2C3pRM
	7XxeQzmT20j8qm+5RxGWsp9laqUaSSt64HakfZm4Jbx63oa8aDwOnVv/kk0JVNWTo2WGOe2xpMIZh
	8niZB0skgoGcsid3qyoi1miYCsDrgXEtVNSQjhA7FkfJt2f9jRlPPmy+/6bwCiP59yJ8NWuPP9RtY
	ds7zjAW8xXhH4KGuLFq7aUHj0qqQuxrzZK9m+GZ5k5jaLd7dL4EMT86KAleKoNQwO4OoXGusU36A+
	GGHl0DEA==;
Received: from 54-240-197-235.amazon.com ([54.240.197.235] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtnML-00000000Xsm-01m2;
	Tue, 11 Aug 2026 14:21:41 +0000
Message-ID: <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand	
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko	
 <mhocko@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Simona Vetter	 <simona.vetter@ffwll.ch>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse
	 <jglisse@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, Sean
 Christopherson <seanjc@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, 	linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Date: Tue, 11 Aug 2026 15:21:35 +0100
In-Reply-To: <20260811135537.GC544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	 <20260811135537.GC544626@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-AiQgsl7mjNQFL13X0sAR"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E9FE5C000E
X-Stat-Signature: i7pggq4w3pghfktwz495wd86r5tyc79a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786458111-389757
X-HE-Meta: U2FsdGVkX19kjtoU8Zh10FCGTDn8BfFqgBsGaY8EcmyATeh5lFrQtUNsobgSkMtzB5VeISNnsamJUGgyLhBlAfUHrws+Whu3jPwQJmxop0C+ifr8DyzAfaR5llDMyKMOhjIb/Pdn6kz9APj1lV+sTq78Svtiju5G/xJub6wMdu3OX06wK1mia0t7AYAoAOo/bxDBmCxaAEbjUM8IB7YWKr+1Gp2JjYhV7vLT7Lz4HMe5L6FHGT4Jub+s5eK22ZH5GbhDzhHnm0Ol0X6MaEKNo/F4SrDQImhBvukQTk2txVDyYWCwJWB7nkSPU8oKOiXisF7klhcFBbO97o4Ik8AC5+nTcpsri+YayB6UoTE8sn+1s0yF+u1oUtYZtSRfj89dmVtBuhyH1hgG3MK/EDQz29XLzm7TALEbxAoSwpqn01/P6XqTte7PWMYioKoSE2leeLnyxOlVQbkPV0R5akvixcmc3AfRN6jJB+D1GgSyBw0VXuNZuiqLdPXs6EtqwZBYlRzhN01hVGayYxmWC7xW7q/o1/5cEmsAQ3lzEoxvcu8+H/su4To5/tgXq+C3lz8UGE/h+GQprnJFnc0rw/70mrKnYSQ6yURaQtPpvm5YquGXWZ5Eicri3ZIH/cH4ZWAW7LnSOXxv6TvZv11eJnFnas1E5JM+LLTowXO6z0BUKbPxkIZkxuVvHYqCc/vh0wy8izVhGcpZS7i58etDW5YnLlN/k7RlxMooNHR50cMCdnZQl94emWe225swonaAM43rr/6p2iKvKMcNAdUtPgsGuOdAx0MlxDAb18PCzMtlPxBgAJJtgcSOahSmECLryIhqHSrY29ICzaj0QKIy/WJIrjdC8W4Am7JSpgmnrWgdAwUm+ycxXFkWPFFi+yZjC3aimxvaPG77JwmjOsXb86q/yXHOX2+jOuggll9+NpegngUZXnNvnETHScibATgmPxjZ4GFtf0uzH4HrszneaP0
 BO/bH8kw
 MiOVdD10Fos1GgstJpClCQwKr2TyllLAvr4g4Eg0wT3fof7xx3OEWrdr5FITyXOMpUthpnk25LMJF/h0nczVL5OlAqptVCcx0xU8ZiGCdfCE5eLJ42IFuOnZhxpMDuOBDTcfihUrfv7WiBJbebPDlPSK8ZLlZQC7HGTo1SSJVkd/WGNFw5iFLj6sI+8/wxIVsnBtzNcww9a6Krrv/MaeOJX0azhNh4eQXaiV8zNt/8XtZh/GwB+U7rEfpZKsZyOR+ejCSk4f81aH64aSte9isFlu3PJ3TtlT8qAZ3LCzM3oWItMIAhuAClj5kxuxlW1b7WZlVTDukz2yWkWf+tUs10cM6YfJZQE3e8URX7Xm9pG2D3oEdWu0ZuCGyyHaQeDCR12Y3eaoXWWLgdkZD+Zve4JdhutAilVOMaNfdEmGibEgo7GwA2PruGpjQS9EomrhRVDyInW/Y0IiMlEYpnmDEOcebzn5/0tuJpVv6JoMP9WxBFKTkYDQnWgkGxlhHnttWiaytIUmDWt/Dt1CVgg6OXmTx1WHmeMxXqPyd3Ni4sPw+DyyqrXwLzO5n4twF764kZM6M3VFJQgQSS7lhy+s8nC+Lx+PF/VZytO8iB92lvPd9uajzt5VMFvpWvHddpzyDc0Yo3Ijh8voCTk7U21Xx0th3KfMVHZo1imZQHfEIhleKBX+x4LIF6JFFOHkKc96x/Rrh+faLlrtBhCkqAM5ldHFCjiS/mR19CBrme0lkRwJgu5wJ5lqzHO54J4VHSW8cFBYuw1vOM0hHXDuP3Kjwa3RD5+fAStH3clDYq5pp+DXg3gH7wKxMB1HBIR0BKU6wH6xsfAfJNXKfjN9SLPB+q9laiq/E2hC6nNxUOuWaPQE5+K67y0Y86rBRW4C0MwOSL6y63zHF1PLU3HnnWxAMJKURglD0H1hgqcXM3/br2grpapmkSYI6KIu8Q4sD+Y5P0j1g+YUm3hLphf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-AiQgsl7mjNQFL13X0sAR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-11 at 10:55 -0300, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2026 at 09:58:44AM +0100, David Woodhouse wrote:
> > As Michal Hocko put it when the
> > annotation was first proposed (quoted in commit 312364f3534c
> > ("kernel.h: Add non_block_start/end()")), the OOM reaper "shouldn't
> > depend on any locks or sleepable conditionals" and checking for
> > sleepable context was "the best thing we could come up with that would
> > describe these demands at least partially".=20
>=20
> Sure, but we translated this into the notifier must run in an atomic
> context and everyone has been happy with this.
>=20
> > That distinction now matters in both directions:
> >=20
> > =C2=A0- On PREEMPT_RT, spinning locks become sleeping locks, and perfec=
tly
> > =C2=A0=C2=A0 legitimate spinlock/rwlock usage in notifier implementatio=
ns (e.g.
> > =C2=A0=C2=A0 KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) trigg=
ers the
> > =C2=A0=C2=A0 splat despite having no allocator dependency whatsoever. T=
his is
> > =C2=A0=C2=A0 reproducible today on a PREEMPT_RT kernel: KVM takes
> > =C2=A0=C2=A0 kvm->mn_invalidate_lock in kvm_mmu_notifier_invalidate_ran=
ge_start(),
> > =C2=A0=C2=A0 and if the OOM reaper reaps a KVM process the result is a =
"BUG:
> > =C2=A0=C2=A0 sleeping function called from invalid context" from
> > =C2=A0=C2=A0 rt_spin_lock().
>=20
> I don't know anything about PREEEMPT_RT, but this seems like an issue
> with RT if a traditionally atomic safe functions are now triggering
> might sleep failures?

I can sympathise with that point of view. In fact I've spent the last
couple of years mostly ignoring this "problem" and just blaming RT for
doing exactly that, but I don't think we can really get away with it
any more.

cf. https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.ca=
mel@infradead.org/

> > =C2=A0- A notifier implementation may legitimately need to wait for an =
RCU
> > =C2=A0=C2=A0 grace period before allowing the caller to proceed with un=
mapping
>=20
> That's not allowed. We really want to forbid that, it is not an
> acceptable way to implement a driver using these APIs due to
> performance.

Speak for yourself. For the KVM gfn-to-pfn-cache the performance scales
*much* better with RCU than with explicit locking:
https://lore.kernel.org/all/8f41cb82b7c99d5a3d1dda016e4841326b4d8a52.camel@=
infradead.org/

Perhaps we could find a way to push down an *accurate* sanity check
into the code paths where what you say is *true*? I guess it could be
done with a flag on each notifier? Or *into* the notifier callback
function(s)?

--=-AiQgsl7mjNQFL13X0sAR
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
qaTXUAZz2/h4Au/XzJmhvqgAAAAAAAA=


--=-AiQgsl7mjNQFL13X0sAR--

