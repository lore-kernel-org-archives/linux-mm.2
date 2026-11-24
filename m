Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386E2606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YnmUMNd0
Received: by kanga.kvack.org (Postfix)
	id 5E12E6B0743; Tue, 24 Nov 2026 10:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7AD6B0745; Tue, 24 Nov 2026 10:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDE56B0746; Tue, 24 Nov 2026 10:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3E86B0743
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:26:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E3A61C4708
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:26:09 +0000 (UTC)
X-FDA: 85470388458.23.7075A83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B707B14000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:26:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YnmUMNd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533967;
	b=k63EOECAMyzDacl7zVz4AhQjkVWA7UYFBpDV8jzDoo+rzA/riCWxXOGwosIsn291+4pKHW
	m3fV4IysFsNj6Y+JQXSuk2/o6BqA9Igr+HsT40GI+1kcfUBqkvXQv6To94eFrUAC1f4RIw
	z05zqRJe6OXvskdcynMR2WY7HBtiO1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXih1WZAZkIstn+6lWF6B70S60ZNK5hxr3a/V9kUdq8=;
	b=Sgs1pBMbfrW3QBzYbWefCPQAnbm1e+oFAcPmxgW5Zqx/y1Ql5s0EDXVv/lN8gJfmtpQhnn
	5LJNxxRpBcggOH+XcasVffzSnk9XF3v6FhMJ+CBdUm65u737taQsG4MqRL3tUQ+7vzw80h
	0+y0Cy5Dg4cKxZoQ/c/vfGEFT1QtoRo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YnmUMNd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03A7C42216;
	Tue, 24 Nov 2026 15:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D471F000D8;
	Tue, 24 Nov 2026 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795533966;
	bh=KXih1WZAZkIstn+6lWF6B70S60ZNK5hxr3a/V9kUdq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnmUMNd03FVBwCygi2End4XljhMQngJcvukA1YboBhvs9lvrFT7GB0wwo13w9olrY
	 8+BOUVRmfTO2fD8Xn0gHIPP/kNlWYS8MakZ9k/myC3Xml85T14unBesAnkmaVdUs4e
	 DuzXQ1NjPj5hcf96iLkyXRlAu3LpLlUgfF9kn6czuQnhtU96L6mdZfsiwhI8KeMkOM
	 Pd9t5EUHmZpZdL45C/fNCK+8spzjAJDJfMpy7+YYDzp/gge2wFnHjfimema3+PZlfA
	 NSKKt5D0ZkjozusYa1622jDFoggb59Inx7Qoz1o0H6870OlpSPWqRkRGfzUIzvSgZH
	 at2ZkYz9a7jWQ==
From: SJ Park <sj@kernel.org>
To: Enze Li <enze.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Dawei Li <set_pte_at@outlook.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/sysfs: skip registration if DAMON core init fails
Date: Tue, 24 Nov 2026 07:25:53 -0800
Message-ID: <20261124152553.89020-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <835e8def-f4cf-4422-849f-08ad42f47c8b@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: B707B14000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jb7fuhhspksc6usnzx487o7inkiyj4qu
X-HE-Tag: 1795533967-323485
X-HE-Meta: U2FsdGVkX18EGBF8NdiCEJcsh36CemT+DuOffw7rYzKdvLoa/PnO+Ap40M0fL6kV+vd4EP1l+PZBgt6GSx/HESYHMzD6iAAZ+WXxzBkpNJT+WbiCn3JjMRsww/qSpvmvXX1XixoooIfoK227XsOKDw45WuR5KX1mCvYRzty3KlwlVbh56NhYOtamC8158QWXF9DFxmQgedusNT4PpfCkhXBKra2PkXeqAo6wVj2MUvrWYVbG73P5wiXFJi8YVgNy+VzV8wqs+JE/eO5sgDitFpPENjBoFDcZncOu36f1c1UQwIfwau+7eEy0giE6Dr76GCQ99aXVf4cD9uv63hhg00vf02Tcsse7aF0fb39V96eGKFwY3Wto2KNcbOsyCHj3XAiZ7ZqXQ2BTHuIKBky6aeAuf+QdoSKiuxx5WTVHCcPFx5asanQGnGWPHTupwlAdws42VpAttofR5fmE5C35Z0X0c3QPbXZ2BWvIv7AViUEh3UThjvO8iQGpkp/+Hsw2XFkU3/KtZZBxNtkWdpO5EytUfIyQIJi1JYOlDOKD5i3RB+evmZGeupeGxTS67D/XRPIvGNQA/byShauM4RLf6xClCWbBvRFfbAfviSt3t937Bs27iXYsbjmp1o1SplDGLuUF8Dv3R2SfRfvW9q7UPimowdn1NBZ/iCCYCgy1zI/qDNXv1avnRHLPQld+8mERcL0nEhyOwx15UBC52J7b2ToBmeDGzRxeJwQaC+MwOFiG5dhiBTeft0c1KmRWii3o5nshpz8cv+CN95ZyBpT9he/zBfa1Mf79cGYgh4p2sJ3Z+wlJGWP7c5VARS9NUstRvMXVMyFipwz2E4F0os9rGihxW28lgkli70Ya6ZQt0woC++gejoy3f4xFF/Po2lI3tD4xzAw1bDVYYQAeaRezQMCeiaOUoAB+F+IXZPvj7OfUC87foHZP+odVHsahvmQJX245qNbyXiBrfD0f4CH
 XXn5xqWO
 5F75YshVEh05oOD3iTjVi3Ox3wiXtwezR6WUMEkfmm8XTIwmk6pAFLsji3Fhm9zSKbwUIwcNjkksbpn6Vh2ZpZT6kBuNJNkj8twL/ehHprr2SBNc1s7N1yIsC8PfPVFeHaBAPC/dbJSMk7WqmFZvk2DJMDr7o7ScQpI4HLTfwLl4YwurLzgTeWb7jS/xjCZpl5CU9IGvmDO2rwXSTZTmV+N7a0J83VxEaiWWted26O3J7Hqql+WfhW2NkZ8DMn8S/2IsUHzPqU0ofrxL1PnUE3K8Idu5+DndkzQq31ZmE+Uq8lpnrtQfmAgNeH6BlMwzlusbGVKzHVX5lB0Nwv/jcKg28O+RROqPZiX7RiCU88MvUMsXrlzvFYWyB8FKfwBUqM5rKxYntJ84/jbNj4jCWce/b/HBlmT7B2O9bLEMbKaRXzh6oOPoUY3HAMe7V9YjA69Am8xgc+QCAKgM8yfGFmGVrAK/jVCd/O7Nd1TGAXW3g0hi9ZCWM+a0TURyXDWXF4ILSDQzRHARP3eOiIYomrzWn4zxLIvDiWoi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 20:31:46 +0800 Enze Li <enze.li@linux.dev> wrote:

> Hi SJ,
> 
> One tiny thing in the commit message you proposed, pls see below,
> 
> On 11/23/26 23:36, SJ Park wrote:
> > On Mon, 23 Nov 2026 18:51:45 +1100 Aveline Noir <jm5905938@gmail.com> wrote:
> > 
> > '''
> > DAMON sysfs registers ints interface even if DAMON core initialization fails.
> 
> It seems to me that "ints" should be "its".  Other than that, everything 
> else in the message reads good to me.

Thank you, Enze.  I will fix it as you suggested.


Thanks,
SJ

[...]

