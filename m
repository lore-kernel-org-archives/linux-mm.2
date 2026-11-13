Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4276F606A334
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BF6KxyJo
Received: by kanga.kvack.org (Postfix)
	id 68F106B06AC; Fri, 13 Nov 2026 08:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FA56B071A; Fri, 13 Nov 2026 08:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D956B071B; Fri, 13 Nov 2026 08:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39A8A6B06AC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:00:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0485140169
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:00:34 +0000 (UTC)
X-FDA: 85430104788.27.52DE7C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1E4DC0011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:00:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BF6KxyJo;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794574833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXpdjrmHik8VxmCAaCIUmmAMDQ+4+ZSb3XBzqpT6F+w=;
	b=ezTkpuUdUpB8YhLgnOq8huFxNn4MtI9SuM7hjKppCn51hOW/mFOKxMx51sM78iUMW0DWzC
	S5+Zt2eqZ5blDwbHLAOzXktUYo1nbKjGizfmKzECYXfT+MiIpmw6aaby47DTBJ+c9SydlX
	KnbzOH/EpeK0MzJMyjR5hLAbKoCaU/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794574833;
	b=ZDvJRQ8PwT+xg8c7h6fCeV6+I0n0wJdVEWHZ2pr85zFJlJzCsrsY0VB1SbNgnOuh68yQeM
	YzxSHIL2Irt/CgCiMIUn+Eei74YWEPkQH/3onkXQc1xDCs6nqtBQQG2/Og/ZwtmzJC3TUt
	KjbUyS65LUqh/hIJupPPLhNUN8zpG6c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BF6KxyJo;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29C2A4621E;
	Fri, 13 Nov 2026 13:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23F41F000C4;
	Fri, 13 Nov 2026 13:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794574832;
	bh=iXpdjrmHik8VxmCAaCIUmmAMDQ+4+ZSb3XBzqpT6F+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BF6KxyJoaqun7yvquPMrlDlaVyVUnjVtisOJkuDveMfAONqiyhXMnYZ+jba6we/Nh
	 0nXWG6EArsSCEIpSuCwD6qKrrGUyQEl/o0gJU0Ha5fLfVPy/5hh2gVNH9X1bwG7fiq
	 a/QW5IuS5pJMMpocWkEZ/oKcE25pze/t0kYcdGAWRkSGUaRVvXiZIP12u3wDwT2uaq
	 05vHL2oOpjxzh4z+sqXlzm0fawvNr2usV25AZ5/V7eVOJxvo+ueIzja7J3jK2uRlbz
	 E4q+9YDHcztpQYqNN4E3LowAXWY8kMvJheY+DBIwnc8JQE1d912n3J4VCNSf+Y1q/g
	 jUuefX2matdoQ==
Message-ID: <sashiko-outbox-212803@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, david@kernel.org, linux-mm@kvack.org, ljs@kernel.org
In-Reply-To: <20261112125959.177881-1-xu.xin@linux.dev>
References: <20261112125754.176930-1-xu.xin@linux.dev>
 <20261112125959.177881-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 13:00:31 +0000
X-Stat-Signature: rjd14onfk7xrzeuhhbjimy9bhqikp67r
X-Rspamd-Queue-Id: F1E4DC0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794574832-210110
X-HE-Meta: U2FsdGVkX1+4429JMJT1jQMFOm4fvjPf64QFWPWUoNx11dPQHgsAoXsVKI10+Eln28ucwp5zSkYARfLapkzI7o5Cx1xLJ/OUALeem+xdjX2Lr8dDXmJj2ZP8bV66xE41c8wnmuiTlv138f8um5fDDgIAhLG6/NhFyB6Ypj1anh1xmofCc8rJtDsPnAn+GUij2kJVXxBlTRyjEhjgcF97WgN04zc8CnCet3Tnamm3zxAhYUDuFPBgh+GHL0HVJkkmzPO2fKONCpzPcTyapppVFxjy4Sg+9LUR6p5VP1nKH6iv3CpRCNsIdPhD1o6Ar+B4afboVbRtj66mAtpVCKYSGM0CxuALmatMojgp4jW3z2iSgNO8k02ZRryV0LccJlegpcCeaIzU820kMeBxqgEc5jhohoyY6f2/GA748RJasowqgHJo58Dwv1ZTmiIBqbzsFO8+anVOV5DQeX8ZJMd3oty9oIGO2LajTSNr61hJcQbrahEGMWzZLGIyxKEZ0ZRzYUUuhHf5KmgIjlpejq70AeSF9KBWqdjMkbBgG7V+n7knbPx0q/1ix790TheLLu6YA1jvFgJf/uTjqhKSyoLzS+qWJqUSffDmUB/xHMHMBQc82XmHEW0a32BOYVulPAVW9gP+iyxsGKkoKBvSEPpkp+ti5KF7PxFZGtVs7SMVt3YfAjgTVPNS6F7Mt8x+BPleJ2Fj9UG38hFw8ZWMjRn2gYCyHxcqg8oYQsi7mkCDZOyiDZIAp8QqZsLLw7vawxEo3QVVTgkR+d6Une4c8CtHvZ7aTxPo4l4b0RuynbUdyT0CNHKgzr5HACbK5ohLMEUyu2bjTkHrRDBoJRG/JuZhEyEbadV9ZQ8V1QBEShp7Gzl/rZWrtoEWlss54HQYvoH5sonAJKMHtyhlaWaAoMPbSduOvcEbMAvWSkYHlLZ/e8JhfMVmmR+RUzgHcw8P/aHX658nZntJVn35L/QPFwP
 Eu8KS/Ek
 l9ap3UTOtwFdMrvRgvzPbEDTBfvfEgDUpKo9AGb0ykgdfa7eRpn49waM5hhPuXaCGwgQdKjmqbMnjrzqbFUhDrBp+M/0R4FJblHwwxa5GVvLuCeYrGFHSMXsO7itEUYb77AwAUZ5P8C0oBGVKVCNEgk0FQRolsAVKWRsk/knYx+fhIIs54XXR4Q3qClKcrejFT5Be1fP4LryoT6PEUrLNcXeVLdmqc5OK9vAd2RQ6T2ADOblcR9xsUPYJRkg75osonogKcJZeR3FUaHshqx+nAfW35FZ6BXMuFKO08W15soBGSaVz50CI+73Xiv1rMa7lm+znH+i7nmoJL/jAXUHtnSZNnnsz675DApjjkxtVmKjmNrp9627O0PnkTiXySz4RGIjmWmbnJOwk1/ln+z19S5xHp7oi8Vpfkg4DFiubO1JCOaQE4l1J0fkh/RjOk7PzzWJhuNIScB8NL90priBu6WQaVaw8YjalX15/AhnqBLFVp1hRrp1JnZ4srj3oKPstYOzCm1XD2qws3nNI16g/4X5kHw4AhFo9NEMfz0PwU6ARdSsuZ2RBdkvSwoTC3ke8nq4RhZK8bdVIiw9LWxAE+22DIWgGgvgEZKsimVni4foFGrE505vMS9+tp6lwOtNL4+RPOvVlVUY3gcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/ksm: scan_begin_new_cycle() reorders lru_add_drain_all() at
  scan start
--

commit 82208b052cdf6d037a169e81cb68de5a2ad7f1fc
Author: Xu Xin (vivo) <xu.xin@linux.dev>

mm/ksm: add initialization helpers for scan_get_next_rmap_item()

This commit extracts the new scan cycle check and the first mm_slot lookup
from scan_get_next_rmap_item() into scan_begin_new_cycle() and
scan_get_first_mm().

[Severity: Low]
In mm/ksm.c, does moving lru_add_drain_all() into scan_begin_new_cycle()
change the execution order at the start of a scan cycle in
scan_get_next_rmap_item()?

Previously, when ksm_scan.mm_slot equaled &ksm_mm_head, advisor_start_scan()
and trace_ksm_start_scan() ran before lru_add_drain_all(). Calling
lru_add_drain_all() inside scan_begin_new_cycle() in the if condition runs
it before both calls, contrary to the commit message's statement that the
exact execution order is kept intact.

This reverses the relative order of the mm_lru_add_drain_all and
ksm_start_scan tracepoints. It also records advisor_ctx.start_scan via
ktime_get() in advisor_start_scan() only after lru_add_drain_all() finishes
draining per-CPU LRU caches, whereas scan_time_advisor() still includes the
ksmd CPU runtime spent inside lru_add_drain_all() via
task_sched_runtime(current).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112125754.1769=
30-1-xu.xin@linux.dev?part=3D2

