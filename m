Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FA1C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35A36B0166; Wed, 12 Aug 2026 10:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6D36B0168; Wed, 12 Aug 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC616B016A; Wed, 12 Aug 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68B406B0166
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:38:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E7901203AC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:38:36 +0000 (UTC)
X-FDA: 85092873432.20.BCC21DB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id DDD19A0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:38:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DgBoIh+z;
	spf=none (imf15.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786545514;
	b=SnRuVcavXo7fA1H4qXC41GfRYvTbls7PUpiNQWaAqTpdpHXGb/0G1TSqwKKFn318dD0rmo
	fVv6v2FqS2RWpkowxLoqSemx0a/tQOhME/O8J1EdfjJFovN8hXYOkItNoNUl86GqwZIWDH
	h7sbaxYqU+o1hauMKgEv5E5WUDShgto=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DgBoIh+z;
	spf=none (imf15.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786545514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93QnXaMOBw9iqWgnQ+zhbLuL6rbaVZDDgr9kabywcF4=;
	b=5xF64oq09T1EuPm/iPKKsH/xqdKOtD8x0VvWnhxi7N81oA3N+9IkJPD+7sM5cvzWNprkgP
	n6U8Qn+3D+L0ZWS0ipZc1LYabJh20WOj6QtdOkwHinSC4VBWyfisrvmfTTmWRsj7xQGMnM
	iPJwCmqec1FyQ002WfG0t5D8dNrQJmI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=93QnXaMOBw9iqWgnQ+zhbLuL6rbaVZDDgr9kabywcF4=; b=DgBoIh+zjlatPFlBzBv8K2LrO+
	MLnj89HLTZL6996fUD41CiRrS5W79jb29v8y4LY6k4e0AFcPTJ/nI5c1vCUL1NeZ6pCma05tBkhdv
	P4Ltm0SInGTNqg0H7O4RxCkq7PygiiROdt3QTgicGXMr5bRkJvQsQKjZoq5qKFMJNFZacurDhGgFB
	6mCClxw6fYVOzVPE6kUyXDsHL3mBI9oQL78jeAUx8yVRTwvMyTnt94h03ogWfAeMXWdpKQ6VyXDyb
	0HsutOpIOgBEFpHcigeUiPGnPzSG30lBAyrj3qhtJiEktsNpYActucIBTsbYS5hK2nbkFKpZpjwS1
	rk8jiGiA==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuA68-000000027Uc-1I9r;
	Wed, 12 Aug 2026 14:38:28 +0000
Message-ID: <9e65be44430e7d013fedf9a1626caba020ad6d94.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,  "Paul E. McKenney"	
 <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini	 <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2026 15:38:21 +0100
In-Reply-To: <20260812142659.GD662699@ziepe.ca>
References: <20260811142730.GG544626@ziepe.ca>
	 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
	 <20260811104229.72fdd928@gandalf.local.home>
	 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
	 <anwraNIKJV8zwrNT@tiehlicka>
	 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
	 <20260812122759.GA662699@ziepe.ca>
	 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
	 <20260812134934.GC662699@ziepe.ca>
	 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
	 <20260812142659.GD662699@ziepe.ca>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-vF1ORSio6Vq2xkEwJ8nS"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: DDD19A0003
X-Rspam-User: 
X-Stat-Signature: umq6sar7qtr773sba6hwucsy6btkyeik
X-Rspamd-Server: rspam06
X-HE-Tag: 1786545513-471245
X-HE-Meta: U2FsdGVkX1+AzItpcJkhGkghQeUtVepK+RLqw8h5Qad6pvW4EZF+aQb/LQp7VV4+ENHKXipe+4SsKChfMqjF++e+8siXryX6LbtFs6G3id2roiA5q2d7M3o0pQDR0+crUO1l8nH8SJ+y8ImQXz1FnXhMmsWN5Gk/5OFWllHHI/tsq2rOo4+KdgK8efaY4I96R03THnawn4dDIIqFtpvbBaxka4Uf+WTVLWHSZZkZoiN+hHDpPDx4SwQNhzZZmK3VMKjHyoyfCfMx5T15ul9hjqyfrrPBQaKMf8xwk2IK2eGlmsMkTL4saprVia85vVKx+jMdW4qFHAaQa/1ZS3cCerTT9b6lIoFXMTszqR8U6FIaZ6pIQMnsofRsPfaIAsIuRhoOjYPSIa2NrtSQZZiuvw5vXm9F9Ku8mPBMsOqEl+NXY/453VO3QWvJogvf+TPN1Yclme10GcOwld9lN+nD3cTu9X1Fga62dI5rCnZ/qDEmZdSAdZQSc+pcdBxLc+2pZEMCcr21AT4F2rW06ZPl+rVhKEiZhFvADLThhycuDzmdl26dovWdybY8/tL4Kaa2c4A7KhV+Ii/P84N6IypyC5woIGLr93wloRysrolwlNGWd/FKrW607jFC3dtVXxTa94BuWcsED6qUdPd69wPLgTL4TLKUbFPtYCSPyWfhnewKX+ViZBHSvp/BSnWusVRFjSEvWDBRRq6rIePX09qSWNdHLdG8fK59OUiqn6HSBzlHqy2shng3BR3d5P28EUebD0PQvAdP9z2rTkKaC+PK0KXgGGrLzLCJEkvrjMjADegNhFNpZHTwKGbYVdRspBZ70xB78BV0y+Tki9prtGBNMxO+qou8Dg7n/XyK7DrNwz5ScygUK38MuUhIbnN2XMdl+Kc7YPwEA/PekdFSvsNUedgwWunwxrZUiZF65z23XD+DIi4JEAx7ogwBY4a7H/z1dQevC25RfeoHdji4EMP
 tcyrXSuc
 6VT3s+vqqSbOsKuJZ/zRG1STaz7peF7yi7vGw852cMgT7qx7R5vfKDg4A/V4JFH76ZpZzaLqkYWlBk8tolAYsnjK812tKfeV66bb2YjcgTIeCdqod2KKlz6hDWoK120+/PhZD6YmuUmevmc0QM24sWNfR10yrxIUD2WUyoEx/TYLDI6O3HtuiS9QYaB6EXqxWHgmqWYdFxkib96l9sB9pkfORHxjvJehVKfnj3PnG7wLvuYfqJW7DCGqWA0thv9WdathBlFvyEuGeAEuA6F2GGRSkaru4ARtV/FvB31dmCoq5y3FpuJwRCj80zp7Sx0VYm5DfgeJQeDReWUJm8cSp2HrrWe6LIfWiJu1Rkgp45smzSmv1l0FHT0bpbwbFMV+FiBKyNHHAO2NgFkoRP+ZD7wMXDfXOwRsz3M3FAWeiCgtpTM+/o7SbyTh4RILNr1juCngBDNsFJyI8n/7wC7/phkTgR+zOYGW8YMh/SI0xMCtDmOf6c59FwVRLKLnCJirzA1J+T2ieCEMm09ujt74wZVCLH70TEiJY8AVcdUN0ul67CdPtcOG1qDrhqS7d11Zo6HcYpFxXo1/Jc7xGwe6Y2NDYjXrW2KT8AZ6qx3jG1+7vB0t6CS+u+KhfiuKLRCV4wULLmjS0K1I61yZYEGhIFF+sM+6BoGLddplSLc/kG2Imp1QwMQ7z1984zmLY4GV9sYmeuhwMJ6lB62OTlDQd8sCIZDmLlX8jyRNYAf5QddQRsFGAgE1/ywrjCY+mrXpu7pNfX1+DClJBCiykocF5WaoKX7MFdAyn4kVddR/QGT2db+l4pcBWI539LWZvsU5nedtZbGLNxENWBOmEnrWkcDoY4GxfqydQHS+oYSH2gq51Goc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-vF1ORSio6Vq2xkEwJ8nS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 11:26 -0300, Jason Gunthorpe wrote:
> On Wed, Aug 12, 2026 at 03:05:43PM +0100, David Woodhouse wrote:
> > the non_block_{start,end} guards around the MMU notifiers, which are
> > basically never being called anyway and don't actually seem to protect
> > against any real bugs.
>=20
> If you think this blocked stuff is dead code then lets remove it, but
> I'm pretty sure it is called and I remember seeing bug reports about
> it being triggered in the wild. Vetter certainly added it because
> their tests were actually triggering and they had bugs in their DRM
> stack directly connected to this.
>=20
> It might not trigger for your hypervisor case but we aren't here just
> to make only kvm work now are we?

I'm sure there can be real-world use cases where it can trigger, but
when I was *trying* to exercise the code path, to validate my belief
(from source inspection) that even the plain spinlock would trigger the
splat, I ended up having to hack the kernel to do so:

https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.camel@=
infradead.org/

Perhaps in the past it was easier to trigger 'naturally'?

--=-vF1ORSio6Vq2xkEwJ8nS
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
i0TLC2WzAdMGvQ9m1dx5GfwAAAAAAAA=


--=-vF1ORSio6Vq2xkEwJ8nS--

