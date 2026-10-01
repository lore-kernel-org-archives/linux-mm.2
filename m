Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735C3CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6336B008C; Thu,  1 Oct 2026 09:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FFE6B0096; Thu,  1 Oct 2026 09:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510996B0099; Thu,  1 Oct 2026 09:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 272C96B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:29:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B46621C21A0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:29:24 +0000 (UTC)
X-FDA: 85274139048.12.B9CB8F8
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2EBE14000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:29:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=of6YJuEo;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790861363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djo86y34WOc5FBXQPseI8JTPk4toU7ySXcp+GeD54N4=;
	b=KkBPsWIlAeNc0wi1Cszrf2Q4xw1Wmb4cEiNiuLLF1NQIJKCavM0kmFBUWs30sFWdvPnFOO
	K2tO8W06juEenqUN/LJNfXBpSvHuQUOpTGDEAAtPtA6qtkh80cleNWEtUFoZgEcSzRQqHQ
	32fjQ7vwkIYmtN41xlQUKZd1LoOQmNA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=of6YJuEo;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790861363;
	b=O+SC8dEQgKVQwpkfOYYMhnEmUzZpkb1tAuzicT5VnPNSbfs1HFXFs2cx0/7qOLRc5NWLh6
	/vgT5dIMZFpnPrwEcd91rMn2jhtE8hLyXM2JuW0zEGKkIVeiTYO9az7asiPvwYAeg8CIMm
	1l1+mOR50HBKbiWJaOsbcFB725/cMHM=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso59720345e9.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 06:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790861362; x=1791466162; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=djo86y34WOc5FBXQPseI8JTPk4toU7ySXcp+GeD54N4=;
        b=of6YJuEoJ+V0aE1QctMhZ4VGxm/wj3h420lRium4u4s9BFcdxXGajctebRX9xg393m
         XKIIu3+8T0U5dUFk1kkGQNoq7jtTk8M42NayM22GMFAL3qZcH4HV+i66pgQTUCCapaSy
         NPtfx1u05pBacc9T4SwhV20S6Bdc5GqUzF7d7Optvi6GkgvEBZT4jmncZ/KzvVj8r/wB
         gy+ascHI+wxnovryRRhOS43F8HBlclSgtAyXfIKi+BDXrTD9+QfyKgw4ybCHSDtPeXtr
         vvFqS8c+cBhW3Ggty21tygFfGkPbtbRMQQf2hjtnHS5dwNkI4Xbbtu/v2YSbxrG7BV1+
         O+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790861362; x=1791466162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=djo86y34WOc5FBXQPseI8JTPk4toU7ySXcp+GeD54N4=;
        b=YznH7oymugm0aqLfNtAQuopfDpKViza+Uwsf8wpQsZh/5+fJAQNJbg0mRG7yF64sY1
         OOh5GFpIfHY0S8nYgfu91ZcbAMHW61bYJon09b1X9EtwNlxs83B3PqoupXR5v4lj/7R/
         pZ42ZzMjbaInCxhQRh8aEOj9DX9F6X9ylYWf2Oe2M9wZu8ApupGazpYFJlomsgO9XNeE
         0K0UtPrBc7vnj2y0RnYiYU2dOnq5bAM1w3Cr6GKNbIA34bBcTvcn3pN/WAMeGffuPptz
         s78thVA4Has/rsZwP2r/CsD1Vc0Li2HncgNZ3nIo/0WUysBIOJyiEJq4ZZuaqeXer3Tc
         jE2g==
X-Forwarded-Encrypted: i=1; AKwUvBx55wp938G2X+pzLVN088XELdhp5I5fm8C0RG/5YQ9onYaUjBC8+Zn+bgU29UU2R48m1RTYpxd9Sg==@kvack.org
X-Gm-Message-State: AFuF++nIoI9012FjtERhp7wtAilX49ciIdGieAwoVDVwpaGTNy+g5G4I
	cbIgl3Gj3yNezUidZx6G3z23EYEyHHGTq4CadmO8EZ3icLTxasvMoq4YIIkKxS8UZP0=
X-Gm-Gg: AYBFou2u6OIRegfYPa9PjFNX9VkAUHMefIJAm6r+qe9ZmL2sBh3I0GnL+QWu9T0vk15
	vWG6S8DjIDtbCXj+fm+oKYghFEoI/jQSZoY5sI2KKELkFq1V1x0rd744Coy13A8jIRH+hMDMjsc
	rzz4uXePWf46PnWIqEdwBuWrbQrpL768xelyonvIDVeftppx6pGwW9wF/Vtbd7kQCYjM4FPUyYN
	CzM44z2mDaOYdyxxhOpbyvlpnnXxAKIJXlGvhBBhRkhTNPrIsOH1ii5W0YJvDv0mb4vyBk2mjAi
	MrWiu4FSKli6OZMJVmXSH492LrLPbNlI7QIOl2wvWx/d3RKeWLZY48/uv6eZw5Lpqd4qBEDMFb7
	nGCBlrxQyshql8C/LkKoZ4svXcjl7jYJDpJeK5TBQX1uWSDtF91E1ewl3m2z1pRnAUfgOuxZnKd
	Spyk+1B0N59EkeTIRUiIQYMCPOCXkAqffpUWsUV+rwtRGm9ogU48UQ0D79r97HxXao+kCnEpxt/
	Sbf4alU0vlAZbX8VyjIl2gv01YS
X-Received: by 2002:a05:600c:3486:b0:49d:17d4:aff2 with SMTP id 5b1f17b1804b1-4a01ad9847amr74558815e9.1.1790861361167;
        Thu, 01 Oct 2026 06:29:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:7dd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a024a85409sm25779795e9.15.2026.10.01.06.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 06:29:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: david@kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 4/7] sched/numa: separate VMA placement from scan continuation
Date: Thu,  1 Oct 2026 09:29:13 -0400
Message-ID: <20261001132913.486570-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e1728faa-5d50-48af-8ba0-5098be9124eb@kernel.org>
References: <20260930112206.205083-5-gourry@gourry.net> <e1728faa-5d50-48af-8ba0-5098be9124eb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2EBE14000B
X-Stat-Signature: 1uqgsmipphjjqjaqxogzwhkgb7maez53
X-Rspam-User: 
X-HE-Tag: 1790861362-268829
X-HE-Meta: U2FsdGVkX1+d2G4VV6ZwISC006MlHVdHW+FhhHp9MwK3xMyfSselP0zR5U9Kmx8pcgmtuTbnBg00nII9cjSW6PlMqjLPdyVjWiBD6d4WdgCMs/WPsfcFq0EMAuJWEkfytCiSZrIl4AgYadUryzVu/lLcgoBR5PUCJPAb94PcJCMNUYVtjAmIkPQs/kLX5klS0jlNAj42hF+Nr/dAMrGbYt/E9Z8hE2ZQHvJqFfJ7bfCT34T7SjrgENKvrykAP7GTd3EWnGTYPyIcJzwoYe1mUx/PD+P7UAn0DgpVJYMkUx6u3eiEAZ6pLPIwDxvivI+aTbDHOEBx8QdXRRigTOzgDR/PAIjxPgd9ZczareEahqN8yt8nFigTJ6ak8D2v7UL1KrAD9zYvqMakjDcsitfrPiw9wkicV7NyMhDwW/ViwqRTbeHyBvh8GM5+3ewneN0OQDCrbsC+FJFrGl+4eZclZv8baVJ0qg86cCj9NkLx8E/IvZg4xPpJL3eJAv2438IWnT6EkyzC87m3KxKN3+ZAHR8Pq06FxG8ZY8UMnssKbdCP5XKm2rOStvBRJFhsI+iZ78dwU19JS99R03FLJ+HsRDBEdU4T3VfEII3dpN5xlM+Gy0Ix2mc9zcTA5wpHXCUTADV+BTjs/Lx8Rlk6sTKOGylYNpfXjLx6QxhUhoMrWcY1Q+5bb4zEh0jaYYvL35CIEzzj5mG6F47ueBpll3fo1KQB1DddSlpBzyyleWIkxjNAfCrRtIQD2nN/EPTH1c2Om/LZXzcRL2RxuubUfDHg+kdSmvouz9A/DXawqHHAS/hZZOKw62B+6RyJdZj7hGtVs/7Cdt/9HemD1kiwY9Vy0Gdi1gqQgzBOldGSS7cjg2VL1ai/uyoNO8lY91vCZ1QAEesBxW+12570iMtXUMgIWo3fwkJJ3q6BMToXPKCv4PcBctsh8DcyQSL5ECwdWZfDvP4rONmxuGrpRSw3WS3
 HgRbFLQl
 AuUSvpbkqG8HoylrrICMYvHuS0f3pMmTeKlZ/acjpkrT/dwo0aGEbAV9I0Og2531+4aczUZfTqiK07pXnRL6lpOcIaUn8Dh1w2+t5HbD5JoX4QW2Zdeuvmh+iI5BddFLxcYztZHE0RzSAylrpq/cd8KruWWkGIScGYCVgB1Xya1ZFY0T3+bz/lNMCuxoqE7u3MwRu3QEFHvaD7E4FWz9AMGBPbVq0v+g7ElNqpkg9P88ZJv5RnZNdTyPHMl6jtD2vMVm6eW2wYWTgf0u3Qpk/Gs8LJfek2/okp2MasmxF33/rtGQXsciPnM9+uFyqdUUQvOEPISdDouO8rWSy9tYtZv2ShWrG1BQg3iRrkddd0loTU7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 12:44:50PM +0200, David Hildenbrand (Arm) wrote:=0D
> On 9/30/26 13:22, Gregory Price wrote:=0D
> > -static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struc=
t *vma)=0D
> > +static bool vma_needs_placement_scan(struct mm_struct *mm,=0D
> > +             struct vm_area_struct *vma)=0D
> =0D
> mm can be had from vma->vm_mm, so likely sufficient to only pass the vma?=
=0D
> =0D
> Apart from that this looks much clearer to me=0D
> =0D
=0D
ack. agreed.=0D
=0D
If nothing else comes up on v4, could you please fold the fixlet below?=0D
Otherwise i can spin a v4.=0D
=0D
should be conflict-free with a git am -3=0D
=0D
~Gregory=0D
=0D
--- >8 ---=0D
=0D
Subject: sched/numa: drop mm argument from vma_needs_placement_scan()=0D
=0D
The mm can be had from vma->vm_mm.=0D
---=0D
 kernel/sched/fair.c | 6 +++---=0D
 1 file changed, 3 insertions(+), 3 deletions(-)=0D
=0D
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c=0D
index 3b30786ded3b..095289d3da3c 100644=0D
--- a/kernel/sched/fair.c=0D
+++ b/kernel/sched/fair.c=0D
@@ -4082,9 +4082,9 @@ static void reset_ptenuma_scan(struct task_struct *p)=
=0D
 	p->mm->numa_scan_offset =3D 0;=0D
 }=0D
 =0D
-static bool vma_needs_placement_scan(struct mm_struct *mm,=0D
-		struct vm_area_struct *vma)=0D
+static bool vma_needs_placement_scan(struct vm_area_struct *vma)=0D
 {=0D
+	struct mm_struct *mm =3D vma->vm_mm;=0D
 	unsigned long pids;=0D
 	/*=0D
 	 * Allow unconditional access first two times, so that all the (pages)=0D
@@ -4313,7 +4313,7 @@ static void task_numa_work(struct callback_head *work=
)=0D
 		 * VMA candidate exists. If a scan is already in-progress, finish it,=0D
 		 * but track continuation separately from starting a new one.=0D
 		 */=0D
-		placement_due =3D vma_needs_placement_scan(mm, vma);=0D
+		placement_due =3D vma_needs_placement_scan(vma);=0D
 		scan_started =3D mm->numa_scan_offset > vma->vm_start;=0D
 		pid_scan_allowed =3D vma_pids_forced || placement_due;=0D
 =0D

