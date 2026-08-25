Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D16C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8478F6B0088; Tue, 25 Aug 2026 13:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9396B0092; Tue, 25 Aug 2026 13:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7406B0095; Tue, 25 Aug 2026 13:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0646B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:48:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABFEC1C02EF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:48:30 +0000 (UTC)
X-FDA: 85140526380.24.6F26C7E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEFB9140009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:48:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L5Q4zaUi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKhRcH8/zOHsMhDb0bkW9vwzHbEejifYu2mBO5mK67Y=;
	b=5zoOp3n19klsrqe1lzU5YPnLk49xPWBNC+meo9iyFzMEz2EFDqXTPt5VoP6dKh02fBsO8v
	RGgiYt5OIzRXlyDuphhKkPOBGiIqdpNYESehDOH1LJnxbXb3fwMVnWLF/BgNlfyrfn9GOY
	70a3oU5cAr0uwor/eW1CVk6kuHIpha0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L5Q4zaUi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+cac146c21b70fe15126d+8402+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680108;
	b=xIkHayNG0D4YAtsFg2q0ccdHg3i+EBlRQ1mL+HozknnWvnvNv5UlNkEnAFP0owuUM43Ge7
	Ek8Xkn9V8hOl/EELKkXpuAVOVcLPCAW4cXtY3R5K124AZdZFoOOcqjccsG27/vqqdLwB0+
	OaT/JJzGzeZJkAa8OPHlZwuB+Lenbd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gKhRcH8/zOHsMhDb0bkW9vwzHbEejifYu2mBO5mK67Y=; b=L5Q4zaUiPQJhn8gE93U7Gw2SfD
	ST2JQSax/a2vR13kbQ9vXMMpa09liackC2gl5htjJUy2P7QOC3xc9lPNMJZZKT9L/dr4NaOXOVzN6
	uJvSE8A960eDX/W7bhXTijGKzk1cKdW+r1UsrQ9oODWf3fYZih1d5a0HKr8XaiwkB8THOAG4cNcEp
	F0nXH0gtRe6+fnShSTxgHYo6Ncxqc3wq1m2ftgDC+B+2GgLPTPDM7sdrQPXLcCa0HrXhE0BevSb6n
	SirpHu8UqU4nU/JLO56vM+jA+AHLDM7Qs1v6y+aEJiBzh8kM8cq7s+gHeb0/V8R+ETkFHQ+tveld8
	BZrVAnUQ==;
Received: from [2001:8b0:10b:5:faaa:2547:1b33:7d6f] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyvFy-00000009Tm6-3XXg;
	Tue, 25 Aug 2026 17:48:19 +0000
Message-ID: <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
  Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton	 <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, Jerome
 Glisse <jglisse@redhat.com>,  Christian Koenig <christian.koenig@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Tue, 25 Aug 2026 18:48:08 +0100
In-Reply-To: <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
	 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
	 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
	 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
	 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-O9T1Ji1KmcFhldanfMN+"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: a4bafqzyb4se5ixuxnz1zu9jgnos196q
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CEFB9140009
X-Rspam-User: 
X-HE-Tag: 1787680107-886855
X-HE-Meta: U2FsdGVkX18XBRwovJEnf8HxITVvdEHHlnv1TXRe2AtFdvwi5GmVJ186wZmzBR+VI0s0iwLDPCMXYXqGpprSyjxw54A8cTYIZX0L5w1QsuMid/GPzGHwyapzP6oyURKq7wyAWojAEIPGLM98eLUQzcYMMCVZemd96XrzLY88tvfVM1OGvAPAmZw003tE+XoR5F0c14xERRSQ6NgleNsXk+OUkC6+KUBeV+4VZZ8ggwhG+dtOni6pazTpdMecUXjU//QOthQYKXhrjW1TLQj6jLanba4to99U+MlLzZ9MASN8hcSGJ/ZEYn48b4SB+1amsRuqOdwk79Y9i86kzs/8OoYHkf1ADtjaX0kg0dpm2nFfGrpN/vA2kVqiuB0HVlfa63v7VA7iqD9ZpuIQy3+r0G5w5W29//KPafjhW0KvDR4DUFeAUS/GcY5xbgdP+APh30PXEvg4wYZt4hrnqTOEllGFOrx0tWXGsNPY203eWY4D08mFGExwuqBQGrh1WkW8lCqF/bVtwtFTyIuC9ZXL8LNdlZm02HfdnvZZYUzaZ2Jf1puOIFwVFVmQNhxojeERtS57fmLp4FsmLlsF28r7c2jmqS1go7W9DGipqzDUUaNuCvQBCszHkQtQsoTDhafcE+RC0cPpiJjkBpaetiA5RDK9lCtiZLFdrDynCH05zqHXhBiIuO0QYYJsHc28hUEhtTiuHc7iuRb4GpjkrP2dHt2xNGGlZsYUNXTY+78TuBTxJdYXANptSfGTzfC0dHOk7Nn9j4mrwTB3AtwBfyQl4/mQB+nczjAmqMulm+aRWZW8qe207IU2gnh5Lz5vD+nG60NlV3N8F6zWMrq5Gt4v/UKmJHbOFllV+67uSHEWGie8iKeYyJNsYZIZ3mm+QOSKS9lQieRUatTG0pZDS1K+piHSHN8hwOTtv0Myscw2/1dc8y1i8Tp2TUI6FeIXulXs67mAIh2FwtlcaOkXxlZ
 UH2G5Us5
 3yaeoDnqG8uVUHSgU2ZQMAUR4rrTQh0xXS/4qfCehGl/dhAODV5EhO0yhaqiQ+X03EVX2lQHIYv+sh/Dp4nxr0P7SHt/5qyhD69h3hn6ATeYO/8umj+dJWDMqqRK5W3jmGq4NS3aWfbeRqNQodASWfk9m8fpwGZueWGLp1epNTHmtcqGA6t77QnThgKr/7Pq6UqXRH7StnF7QfGLZfAj7RiGEbBl0Yae0E5To6rMYL063hRHcO75hq+x91wz/8vxMI5RFW2yVMtIxvNbsRk18Y6U+xK9VfqdLV3yQPehinFGSaAE2yg1pXVXxwmgIubnkrphiuSyACYPJi6mamP5EagzMr04nLQs35ep9jMoPKzkq9OyXlLYBfBJurR2doXCOJsX0cNd3k7jM56H9VX+w+qTiX/N0bdWWHsGfTW1V84uYsAsLpUqnno7SK1sAkJSwGO/J78iyvU60dBqI+m0NPc0AAq14sMTeH6mGYtu22c756GRHBaBAahFFHiGrTaC97pf0RK5f4Top20s+ArO6VAiCWabd29VAydCoDRe4Bt0VAEKURO5t09GB4HGuJq+u7bcy3WewvVmsaw/pC4VxmsVpur9j89oMUBQGm6yueDbDrfDyQoJOWBtBcVDIWUwKcmaT40duq9XVOp0MvXbgRsn3ddwTcgOeCXbXupi+yUvjpOewn8yUmeAQb67Fv2VpwkHvUJ2YWRWvWAs2j1OkolPk500jP0aXtf+zRdP6otEHRaYJy+6q7sEHc2eYdYC0ZO3XYIHc3Cyo1QLv7mHnumD97DIE2eAgrCmfzxxE/90TiZe7XluRyF2wUJIIFWYWTfZwJ1zicCmdOlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-O9T1Ji1KmcFhldanfMN+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-25 at 10:19 -0700, Paul E. McKenney wrote:
> On Tue, Aug 25, 2026 at 06:05:54PM +0100, David Woodhouse wrote:
> > On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
> > >=20
> > > On the tail latencies...
> > >=20
> > > The easiest way to reduce them is to require that preemption be disab=
led
> > > across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions and
> > > across all calls to synchronize_srcu_atomic().=C2=A0 Without that, th=
e problem
> > > is that the scheduler does not know that the spinning is pointless,
> > > and we cannot use the blocking primitives that we could otherwise use
> > > to tell it what is going on.
> > >=20
> > > So, is it feasible to simply require preemption be disabled as called
> > > out above?
> >=20
> > I'd experimented with disabling it around the GP driver loop in
> > synchronize_srcu_atomic() as seen in
> > https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=
=3D07165e79340e
> > and that didn't seem to change anything (which seems reasonable, as
> > it's the *waiters* that were descheduled, not the threads driving the
> > actual GP). So your suggestion that we do it around the whole function
> > certainly makes sense too. I'll test it.
> >=20
> > I do wonder if we're really doing the right thing here by selfishly
> > blocking preemption because we want a specific tail latency to remain
> > low in a contended system. Maybe we should allow preemption and trust
> > that the right thing will happen? Maybe the p100 isn't the right
> > benchmark to be chasing... I'm looking at it because Sean expressed
> > concerns about it, but it's not the only consideration.
>=20
> My concern is algorithmic, not benchmark optimization.
>=20
> Suppose that there is only one CPU, or, alternatively, that one of the
> atomic SRCU readers is pinned to the same CPU occupied by the (higher
> priority) task running synchronize_srcu_atomic().=C2=A0 In this case, the
> call to synchronize_srcu_atomic() uselessly burns CPU time until its
> priority decays, real-time throttling kicks in, or in some configurations=
,
> maybe never.

I certainly have no problem with a blanket preempt_disable() around
both sides for algorithmic reasons. As long as we aren't *just* doing
it for the selfish reasons I described.=20

> Requiring preemption be disabled across both the atomic SRCU readers
> and the synchronize_srcu_atomic() avoids this, at least when running on
> bare metal.=C2=A0 My (perhaps naive) hope is that guest OSes get some use
> out of those cpu_relax() calls.

Yeah, an overcommited guest vCPU should be able to get preempted there
by the hypervisor, allowing other vCPUs to run.

--=-O9T1Ji1KmcFhldanfMN+
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
od0AzpiD6XpR/VNQLAEIKUMAAAAAAAA=


--=-O9T1Ji1KmcFhldanfMN+--

