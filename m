Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45A2C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19986B0096; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7E96B0099; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7276B009D; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54F256B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8B451A06D4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:32 +0000 (UTC)
X-FDA: 85321865664.20.97D2BD9
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F864C0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lqhvhJhj;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JGzHzCBR;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qamj3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=;
	b=8V5oBZRdOWcCTAhsxwmkXdTj3JRHlcaNNCMq1OVzh9byL5csJoAThNanf2NJSopnsy/Zij
	mHWyLaa7+ChaW2JpczlyCy8fIRdhiAY5o6M/WQXVmKuMTLRAZGzI14m1o2Zr4574RCurV0
	CXUZ9DG1K7rLeGOy925GCDolmWfqiyw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lqhvhJhj;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JGzHzCBR;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997710;
	b=LZLOi/nrq55PjNnuagKQNhGTfrYWi3X9FsoizYwNkk57Vx72Xkq9zUyDUWlpvCW6hP2Kun
	0abjwKmlzFk/ImgCiH7OUgMRgQYTGnxTuJEkfWWPP16FXN5dPDAQowRpX4AdYFt6MBeMiC
	lVEVZLK0laCngkDU8KJ2TRzxFQf9Fj8=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYPT93055595
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=qamj
	3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=; b=lqhvhJhjucX+yxkQcsgI
	yM9jq+Cw0SVuPisusNMF97Dmt1iBvC4gyRVNqfPIcvpgzJcRLXbnzV13fL/dMaWo
	y4+TiWc3oHCHs13cZjSk7bxtkTjyXxZxsOFzvpwR27cUqpTNjGT7mugAD4Sb/47w
	WUQG4aCvSnNLle+CPRN2TUh8tmgkm+o+Wq9IpQZ/0fvZNUfFSfuRIRYHUB+RxmzY
	gAXCA/kD31EgpsfNrw+3B+X2QtCrJ1K238EHqEYQOY4SSgoUDfZuHpEtGWyiTWUp
	1CYNBhBVM2qfvo3+ZuHiNssSKd+XWEbeorWInKhMVjWtLt4eX5Bzpa8V7IoJFLyQ
	Uw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h9vsy629k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:28 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-535851217d9so96279791cf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997708; x=1792602508; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qamj3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=;
        b=JGzHzCBRKsqm++9No6Bxz3hIPvn2B7SqfwcPVqOC/awR0AzvsALMs21SUVAMTCqzLx
         OWG/8Sj1H5MB+QYHhrivfm5P5nwxa0HLnJeuYGu74pRL6TIrJWfWLJUOcIh58GfcbWVC
         AR8SjQt1aCVKb+pg1RVWbF26iXVXojYA90uAPBonZUBCZAlbqSS+L1Mz4eSsS2myMMbF
         NluIekbLI5ubqxLzwb4bZ8sYzzmbLNLWbVmFzgI6bshOLKzHpyfpT09g+Qp+GT5ltGEq
         4Gn2VU7P9dZdgDBcdrxqTsamoEY264rLNV+UbeCfZyzIJI6a+IzIIn/UGkVvvSykZg91
         HjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997708; x=1792602508;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qamj3Rybiddl1bXwe9wbuQOMEaZBgA53f7HcjTbkGoc=;
        b=Y1QwsCAcfXyhUrfZw16rgcGqSwj95I+mHkfpXUdQONoZPEpMXLAsIKDEhywAnLDP2c
         WUOZDV2wKzLN67GRBjFK531hhHNKYpAKth+Jop5/jYVEIS9LXTjGP4gHGnVX1wcdERPg
         s3P9dGGm/WAxcd/YB7SL5Xh/yFBfh3ZPukwAM8hjZBWO3tHFkUroxk09TsybrfQtoKZ3
         ottYR0TTSt4GhLjzSVr7l/2SX8Mxs7IjeC+fwm/Po0MvITVbrpoSycb3JYo22tDL2Wy4
         PSuFM8zFRRXY96yZvD2kmvJBPTS2VTlTpm5IuU2cjkBTCJ4eAFOHXlAPZl5OvIqyRwKI
         bnag==
X-Forwarded-Encrypted: i=1; AKwUvByeOicjZxeLdIUzDmrgWcFsi63Ic2UH+7YGfoFnhdXo55J397AcOecpD8DpIJ4ou8YD1zAu98PDCw==@kvack.org
X-Gm-Message-State: AFq9FYL7bACb0ZpE4Sg7IShE3Ns3QGHb9NY8qLJf3X69vLIl1u7kBpIt
	UCkdKuOhdtDuTolXcHcuhlGB2STSyWi1Q47msZTLZe0zsbTkvEAupqhC8D6CYFUuoji2AawbNcK
	SneV4Ws6MTws7VSv8Je9mSqcND+08YHgDeY3HDjZKZ6QzvwwV
X-Gm-Gg: AYBFou0IK32vYH2e9aqnHo1IBuIl8/noOtxiGJ7qnG20xnU3p0wX9lGoXvOxIo9Jusa
	j2nXWUIVJ/BfXNYk5uqoVdwXdBjD4VXUtzc42eeWe71Wp/2/mEfp2utiaiwb09Mp5jeKP+fZbAr
	ww5vzglKQ2MevACMsg5oUY7UVoXhj87/bcUXWYqLYslTriOj0qpGRcRU60kCioxb4aUWsAiU15g
	6XK5RkC7FkdDYZlccO8L0hVy8YTfycA4IdPOuMVlcux3XnYDlX1dZI+JnZrlpw4nnpjVIORAvvy
	s7oQ8PPvjc8q56rPAhc/cwA7dMLh0XWMKAGgHZYNEaZ4+xnlSOGBTO5vNY7Lj+tz6S14DIaEImi
	rKtgVBRR9ZXzy8SpbnAQP1Uum0vlTOFmTvyQz7c8RPbZxWXg=
X-Received: by 2002:ac8:5743:0:b0:533:90df:fda3 with SMTP id d75a77b69052e-535fc8a0915mr55202211cf.50.1791997707705;
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
X-Received: by 2002:ac8:5743:0:b0:533:90df:fda3 with SMTP id d75a77b69052e-535fc8a0915mr55201731cf.50.1791997707295;
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 14 Oct 2026 13:08:20 -0400
Subject: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=1533;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=A4+6fw0Hc9Z0q42kWQk0GUf4UVLOksq0fQyOCy1QXaw=;
 b=H7zGDut/q/n0LxMAJS6A5fFSkWckFdgdxTvxrNY9XHYWKdppXxMb4q+0U6DLzGYTRwZnhIyEA
 QlnhUXg6FWoA+COdCszz4UMMX3KRNXyOvTJaLBa5QVIC7yStXh+ylHl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX+x2l1JG74ODi
 huQUqEcp7S/l8nUJ5AAws+nNQ6yEXUkvU8t+guj++B14SCXRK9zXLLopRwccSTbiU/smX9fYeOq
 V31PE9gpJwpYUMsETQeLZcM505R4+kngSCOs9i558A+Dl4anbQ58mihXlK9T4zJBwLgIohD1AgF
 tYZYK+gIdMknpb9M6W1GauhJmeaIsO/KifhOGjC1F+KRNwmoo6eklGG4MBC2sNfDYjSi3sjg8Uo
 DPfbozBToMCEjLTHDdPuiaBa1UCtqaVMH2V73sD4O3Zinhafqm1fS/ep9Y1AIx5DT2LIAiI+nxa
 X0yrHLMX0yBuGZJdoAkM0n2OpDx7y1td9/0RV/O742X2RtooHkwymOyquFVCpTBHe0IZXUbCvM+
 AoUve2Z63j5XphAEPQXPSYHCntcKIvchPN/LVSxTcGECH86cD9kgAlx4bChAMQuPXpQ2MchZgkw
 0hwb+YqPIWuVvZku1gg==
X-Proofpoint-GUID: IuunoDHgRNaRkP06d36AhCqvZtf1QV6W
X-Proofpoint-ORIG-GUID: IuunoDHgRNaRkP06d36AhCqvZtf1QV6W
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfXyIOI8G3xz0+x
 fESPi6ptTRk+4SwXt4OcQEn05yUVK+tEO4TiehzfPOcZ7TFDUEuFJF0e3Rk09IORZheFAACdT5x
 QUcEOh9Af04gB1vEZ2pVvJLfh3EB4QI/A3HqrAhYgcjPNczkLvve
X-Authority-Analysis: v=2.4 cv=V8/oQuni c=1 sm=1 tr=0 ts=6acfb70c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=_9uCFvy-xzexSrfj3z4A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=10
 phishscore=0 malwarescore=0 impostorscore=10 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140068
X-Stat-Signature: mcqt7omzz5wuh1gj7fmu6mbjnhcnecbh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F864C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791997710-404534
X-HE-Meta: U2FsdGVkX1/07en95M1g78Q8PthbL0/66y5txEFg+PZlBhWuxxp1W7ub4tjrXcwxe3DAGPz9Dp7ykzBi5fkZtlQfEil/JIfcFawvm1CXdLHkY+gEb0DjFb4pubxyufDzxN+QdpZjswzmLq9kfNqnaKJN6/e6FzA3YvZHgBI0JQuxKr/p/f4ywdxFZ8QQsL0mcuP+amCesg+G/fiB9se85CrcBuWSyGm4b2RGuydVuvQKKuY0E1SJPuZR0r3lw0pZ7SjNCLfNr0AdriYUXrOFryUKlOQfq5lCNB51iTV/d9GnH5d3i45eS/Wj9Y0YsKykk/P0bF4WO7rkm0GcBaPIFbFJ5bY8xav9M+hiFTyyBUyPDQq0OfNPAX9sWYjx6n+RavvbTILEHwfklEmrnt14vokQ4w5jyWaTeve9ryx8nK7RaTtqAG+8qDrJL9jQrJhVOqsHl816YoCSKPqO2Oz/PLF5JrMGVvG4u7bRRAuHQAMX8YkTa/oMZ0NVhwyjwm+TD4cQ0UU7H7/cvvVU2VFBhVaYyRexveDQ5Hbfz3guvB4xsduRXSmr7f/ijm4tcxIVIHRgB++4DFLBSbfsUfPW7EzANfSL8gB+E1KQjRX/jTLq3pph42Jz2WsQjKhk9cA/W1mlRFa9cDH1hlNXdesrxyaIMOV9OcUAXtVRtaLBKy+Tt5zapk7EKyR/68kVTgDkAgjAk1bKLcRwqI+45Lq91/9Ai4O/zNiMss4qwfqc186z8j8w8J/yEcEyLORvCfkZ5Cx3RH5GRIs/1G+2HE2/0Vj7gsc6J6TI552eUQNIcRiv1MZUCd+BJeZZO7FV/qzOTbDWYhZiaK43dgynVMZFYleH6CSNW2E+Mok7ykrjLD1kGC/X0IFF3ncNZF1tj29fgni+fFU+BXSZpvR/ZuzFJuJhhREsuUoqW0/2YZE2fCFJk+pGJGnqBR0ObWCmc0zYEqxQc5JL2Z3ouHLW8zv
 0a6fui1a
 eB7/YrGWwEnH6uVjqKXB4sygWX+O7STL02l1dC/bKFj5PmCyDwkYMUEcZ/jlkSHcTautzeNpYL7MeTvFjVnYEHm3lN6rWaOrg7dGyHd3l8DyS0AbTas6VIzMKaKWoFYW10pZZHUBQR5DkE9QVkjgx5ir9aEn90I3aFlwxHo+FW9f2ngRN7s+Evw/Ls/ax394wFYdNZ8DbSHx+9zDH2yiSwZ3bCxSA7TEJBS0Q1U9OW3RhDWWnhdpzPmDT2C6KrpXjh9aelBuVjPPPojx2BckWX91uXLpc0g8EK/6kcFhpOsf6JDreIReU0rFYrkA4eBaiu0U6AYdc1+A6S221XvoL3x7RE7/AJ3q/g/PFBlTcrsUpWxwlastqWT2rUkigHvNhWL5QmB+NSuaa6VeQjnqlNuzIxfj2v3uH/phG2J5r5DdmWVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
switch to native NR_VMALLOC vmstat counter"). Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..b65a2d0fca3a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -957,21 +957,6 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
@@ -1412,11 +1397,6 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(const struct page *page,
-					enum memcg_stat_item idx, int val)
-{
-}
-
 static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;

-- 
2.39.5


