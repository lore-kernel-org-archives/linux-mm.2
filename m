Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D33C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 05:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537B46B0088; Thu,  9 Jul 2026 01:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FEE6B008A; Thu,  9 Jul 2026 01:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401CE6B008C; Thu,  9 Jul 2026 01:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0306B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:14:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 965A7120226
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:14:46 +0000 (UTC)
X-FDA: 84968073372.22.8217441
Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CAA340006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:14:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=FrA8MWgS;
	spf=pass (imf12.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783574085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=//uLA+s6qwaDTgsvTiLRg4jEcoe8gz5B2XgMn4s7FKg=;
	b=0fi2dS0G9zdCbaIJ+YOwkei1pxTMuNVS56j35NXxobkkzUh0yt8CvVVuoLFBXgzpEV3PcI
	U/lrVAf890IsTsqzPcYCMSSzFcuHThug29tsrzVoFtvrH0KjdJkIFdl09Gdrp2OIpS2leC
	Vi/Gq5Fz8Q06e5fHnO9E7Q4BiZZYz+M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=FrA8MWgS;
	spf=pass (imf12.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 79.135.106.96 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me;
	dmarc=pass (policy=quarantine) header.from=proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783574085;
	b=F7Up0fhpx8qdoN122wY5MJ1xm1dWvk30+zBoc47jb1MyVERbMq2Y2SXapReIDVz3FCsUTe
	qPL7TQr0ioyZHA5Zp8xJdMBky7sKDl1cXYmZgHRhQqZZEPLjvG+T0AaNPKX60//nSubgp9
	3UcWQVyYcksUrRnsucy+AcAhw3LYvmg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783574082; x=1783833282;
	bh=//uLA+s6qwaDTgsvTiLRg4jEcoe8gz5B2XgMn4s7FKg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=FrA8MWgSX8EAeMxc/LECNUan0idpSp7JLCWZWnkIGbyCWCjkm3e/QvDYUTqBI1L1W
	 oe++g69ToQ8xlEGGlGGCAtZRdavuYEIhdfxorJ6BatfJ7e2vxQdleKgexLBa7eXTdP
	 HgHjBD4j2zfIl9H+WrGtPwquOPZBYc9HjgokXA3RptdcA8eiTo/W9yMqfHBswecqAy
	 7f18A75Xv4fL3LNO/s+FEljyEH7gnvCM8iko8Y0+6T9TcjqSugIjnZaJsDVWWfKQTQ
	 TtzFRZGnx0L4l3w36ISJxDhvtxNEXPI/JvoeF0a3FT5xjwFgozOAM/TKKpcSVqi9lD
	 bEjwddCq+TarQ==
Date: Thu, 09 Jul 2026 05:14:36 +0000
To: "rppt@kernel.org" <rppt@kernel.org>, "paul@paul-moore.com" <paul@paul-moore.com>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
Subject: [RESEND][RFC/discuss] memfd_secret(): opt-in visibility for security monitoring (eBPF/audit)
Message-ID: <MZlCECz5s73hPgQxtqWZ2VbXNTCZnItnwMHu2iZQlRC6ba0B9GuqxT2EhvhwQ-uanBDsNn7Bg09nGVynBHdmSsiRjhyI1udkYbqOoPfpe6w=@proton.me>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: 10d4677c9e8ac675e6b6709b3446567f78dad599
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m5niqi9itoaqxc95chjotm8sad38ijkf
X-Rspamd-Queue-Id: 5CAA340006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783574084-91918
X-HE-Meta: U2FsdGVkX18DhiY2mFZzNxAArhspq4hIYEALh5mkwBKjGGU2uuw56k/T4A0//krySXtbDpDKsOABmD8prFsSVy37EKFYbP/wv949ULcsKEBTZvuxkYmtN5j/R5ZV77s5pMKGrUePHQqCZAyB0z0f+w5MG36y+KlnCKVRT+uEInEzdQNMEOvqEbj7fLIQYThB//+L6yKWPpup0zbedeUMuHor6WxsBm3t40KjqXAHH0daSwljOpu+09NZnwMJ7E3phN0RR8JX71eTzfKRJUnpbezW+H5Z7z3eKWoomQGNMtjH2E/lD02GbHwePzgts0FnufpKkUeWVB/xxvL2KI4+2Pf4Jgb1ys/vzHW/mAK1Lh03Xd4WwZqjCpQlO5kEMObDvcrZKF2j9WyR3237+ow4z4zGFozuRu5tHey/A03oIeDWEEEYhAQ3GqPSdulcSiwMYICBUtKwADWNKmr64EqYDJr8bL9Agj0bwOWXjnOCpTk8upuvS8Bv2rNm/y50wa0edE4INSfPDfaN7EPIq/1/++YKCbeXY4cwdQOS49yOTMT3OOdKUpGu5b+rrRbtEux72r6x1NXSmlegrz+Re3M2s6IYx6M3SQFMFfEnWb6cRDIpfHQ7qEYmqRANXhI/NYYUo9eKomRpoGilgn3YZVjo3uVaY5UZ9qQWynWXBIMIk5t3qNe5Q4h/3L6BUWKQbOn/iPWKzx/8L28zwbGRDCjtYQdrOEkeF8ZlRZlH6ppbv0/VpFuQDEdzSFOLGsIJiHKIQAVOAtQjPJuU3sBRI0Zagzyb4lca2jo1KTQI3GR3D/SmN5nNdlUeN7kI1fWWqaP/gBV7xyAlE45zNU4ipYoi7t7T7qjCHp3aERT4JOHl0+CJBA6eS5JpOzWglLPGH0NnIg/VW2j42g6xLO9e+yNEkkJcle7NpYsd9pHP3Muv3cWDE/gtuhr8hRbmgMzyc2Tu6SZ+1+Irho+so0WdCVJ
 rLkZBi4V
 zRE9Wn/88zA4inrN1TfCW1wGjQZMgnYMoHsKhc1YThIv+cZFyNMDviW8KxIePttUo6I7UGOlnClKAFcpQmGXSlj33oB19u1sqaJ6Njf0Ksstro58qHi43fRbh5QnCJ2BoDKpqJJAmDx7XCZToy2AYHKKxgqqaSTMTd431o1Zv+I6cc6PUAu55YAGsnqAUIyfWEk508M5JOnHNvVUVhYVAhC+hW3x4TEUlfHaCvEtcu7CnxFEU/iJVnzQ1zgavFx+dUPTVD0DRBpJA5UVnOWQaUKJKi2L6kDfm0QGAD2qycbp1pfPo8kWQj41qNCmQJXoR3XqqaMRxApO5a0Z7fJrbftZ1BzBS8nBGSWHNhEv5KuqtCi4JFWbwLcuRXeHfsqggKGqwFwgdWSLMr+FHGjXggz7FOgWJhRhipy9oZ+mLcQxGo6Julm8O26grsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note:Apologies for the HTML format in the previous send; this is a plain-te=
xt resend of the same message.




Paul,

Thanks - I found the Gottsche/inode_init_security_anon() thread and can see=
 it landed. That answers (a) cleanly: labeling exists, policy can be layere=
d on top via SELinux/AppArmor if a site wants alerting on memfd_secret() cr=
eation. Good to have that confirmed as already solved.

On (b), let me push on it a bit further, because I think it's worth spellin=
g out explicitly rather than dropping it.

My concern: as it stands, an unprivileged process can populate a memfd_secr=
et() region and mseal() the mapping, producing memory that is (a) unreadabl=
e by any kernel-side introspection path, including root-owned eBPF tracing =
programs, and (b) can't be coerced back into an inspectable state via mprot=
ect/munmap. From a host-based detection standpoint that's a blind spot an a=
ttacker can use to park a payload where a CAP_BPF-privileged monitoring age=
nt - something that in most other respects can inspect any process on the b=
ox - simply cannot look, no matter what capabilities it holds.

I understand the objection this invites, and I want to address it directly =
rather than pretend it isn't there: the memfd_secret() man page is explicit=
 that its ROP protection rests on the absence of any in-kernel primitive fo=
r reading this memory. If I'm reading that right, the objection to (b) is t=
hat adding any such primitive - however capability-gated - re-creates exact=
ly the artifact a ROP chain would want to call, undermining the "no primiti=
ve exists" property regardless of who's nominally allowed to invoke it.

I don't think that objection is wrong, but I'm not sure it's fully disposit=
ive either, and I'd like to hear the maintainers' take on the tradeoff expl=
icitly:

- The ROP threat model assumes an attacker who already has arbitrary kernel=
 code execution (they're calling kernel functions directly). If they have t=
hat, they can likely already walk page tables and reconstruct the mapping b=
y hand - the primitive removal raises the bar, but per the design's own cav=
eat ("no 100% guarantee"), it was never advertised as absolute.
- The (b) scenario I'm raising is a different actor: a legitimate, privileg=
ed, kernel-mediated monitoring agent (eBPF LSM/tracing program) operating t=
hrough the normal verifier-checked helper path, not an attacker executing a=
rbitrary kernel code via a ROP chain. Conflating "any code path that can re=
ad this memory" with "a gadget a ROP chain can call" may be overly conserva=
tive if the new path is narrowly scoped (e.g., a new bpf_probe_read_secretm=
em() helper, verifier-restricted to CAP_PERFMON|CAP_BPF programs, opt-in pe=
r region via a memfd_secret() flag the owning process must set at creation =
time).

If that distinction doesn't hold up - if any additional kernel-callable rea=
d path is considered equally exploitable regardless of gating - I'd genuine=
ly like to understand why, since it would mean the confidentiality guarante=
e is fundamentally incompatible with any form of authorized introspection, =
which seems worth stating plainly in the documentation for anyone building =
EDR/monitoring tooling around eBPF.



Even if (b) is rejected, I believe explicitly documenting that memfd_secret=
()+mseal() creates an introspection-proof region would be valuable for the =
security community, so EDR vendors can adjust their threat models according=
ly.

Thanks again for engaging with this.



Eneshan Erdo=C4=9Fan Karaca.



