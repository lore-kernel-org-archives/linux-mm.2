Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82660C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6B76B0098; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398316B0099; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287866B009B; Fri, 18 Sep 2026 10:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 063B26B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 995231A0684
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:40 +0000 (UTC)
X-FDA: 85227114000.16.5C97C14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0183AA0010
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SEUWR5a/";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741719;
	b=WQPnBlhgPl5iSvBMIBbOU0VOcE1fsqi71N/cPW1CE51blXHU7rB+oZqcdUAP3X/O5ZIEWX
	RCdvfaVk36OqzU1MlhBy6+UKaAw/Q6L6vf2OQwTAbyTRTTHtEsv0yHjSAAHziJuCsTZ+0C
	eOqMiNBjaENvvSa/65wO1CexSM1E1+E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SEUWR5a/";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt0Ss6VwiTdxRd8z9BHv5kIasgwcGn+W/TUI9MdlD/0=;
	b=lu7WpyGmdlZEd53Esd3VvGJnv0UmQTS1GKiVCwDTJEAAYS9mQ497aUQE4CTTarAFr3lX2I
	UyE0pN0bljzf/3hfy9DfN6OX0GUdYhSELH/H6CvpgpUvYR89+W3tUe12igj9R8681Qsr/G
	/8ITrd0jq7GOnGpdvk4+UAxBp0QyR/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9109E60A5F;
	Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357E1F000FF;
	Fri, 18 Sep 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741718;
	bh=Bt0Ss6VwiTdxRd8z9BHv5kIasgwcGn+W/TUI9MdlD/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEUWR5a/rmlvytL1rFznwx3B2avdQl+r+GOMSLRlO0dkl8R1MFZqT00Tucd4QulRg
	 BX2Wc2aElZ0hFss7sHihs4M6J87ArZ2MHySM1nz3RlU0qzTIsla7LL5t4j+WiF2Rkb
	 GaH9bQ/oeWwp+2MqfeLRFwNigMfou5vQRwFpjrn1IvGuPA7avaheYo1dL66zFSk0vm
	 6xzjYBIL+C1jJsb0HB4CCuEvvgoNdw9GBhly9YK18zwtdwoYzACm12jVVraE5l4bNe
	 yB0LPwO9N5xTpnzFFRitXW3ZmCJK8qkUsgF7a6J7A0gsomXWJUUBFE2fgN/boJI9oe
	 ZYyp1P7dNrUTg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/7] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Fri, 18 Sep 2026 07:28:25 -0700
Message-ID: <20260918142827.85303-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0183AA0010
X-Stat-Signature: jekh3jdjw86w6btpjaqxmqyxqfcbdcd1
X-Rspam-User: 
X-HE-Tag: 1789741718-558204
X-HE-Meta: U2FsdGVkX1+xQdwevaU2H+qWE194hAdR2Nf2+G/1nntTC67g6Le0p4JohYCTrG82MUy3+ubEGa8PKjGDEhvKywOZW03qOo3H8bhNwmJRy/w/TvWbEQmkNjgOqLeu7PcBBEyRpGgRaw8FUWkZJNxNTqc+FOIEpQPJOEo6w1pL/9SVhZM3JRKuBxYklcuEq7nMvlNBznTGMFRmY3aLooQteRFQi5zElVCV0w/3fEujhsWEcy9ZyhneNl09zS4v4OWUoa41G14nvA2DpSA3iAmBnUGsIJ4enN+RyjrL1gZ3/v57MOA38oZMyvT1QJ/+wf8UTC55H659GEQhh3Lt02uyvDO+py1CJbCOZXkUIYCCIhuGI/02VfoH9e8iSu/H18KPLo4vOaxRLzhBV+mSNPQlTy4DhxXdC19bnCAPddD7iFbXK5VaVuQynbxJqe2n3T5VF7ZLOVV+uMzwuNTAh8IMkXUcmMtDlPgcWfSqNkG+x0cFJX5kw73/PxqIl4oBC1E/1wd1DX/J9hmpaWmUeX3hK2wEMjQ62qgWrigRXMfv72IZJ5KG0cBvcCY5s6C0vhEV6s2/LrvzEJyiv27k5IaJElgbXrKhvEZpVDsYm2fKyF/zJnGk+SfUtvConQrV7cGb89sp68Fpw0TQdIcYil+R6avTnorn7vN+FZxgh1DhMLCM5skAIV/FvaHh5N+gnu/drt7xdgvdubxlXsbLvEBJd7iUJlWttG0PJPm0bChrpJO3r0qvFFFo1L5m1T75tx9jJq6ITwzTYBPjxhVybqntZtkEShjImXnWr/CKPAVmOKEfkzJvmWhlsa6LGZzAs1V6/MLM8BsObNmFBYjMpEv4K4HExbyv6Nu11F5x4u63QmhbP40GkpOKKQKDpTcTyyosVeDHM1YT0rQzcV1SnZK1HVkHR3p4z9DsviWL/JzvaD9FINwe5+qZJxgy/PJA63MhlFKXXMeyeDvvMxQQL6U
 cioj9N2t
 quJPSZg84o/nxtPqfxjxzzprhu1qkngNicRdKtrIIfq/B8Z7+XJOLoaomUS1a64NIA8O+U/cCg3AUI1dDk4RkB/D56wEhBAl9TZtrOQmjCYEU8NvMNmqEVuMfLWBp78zfbvkWnJQSXxRSSzXqNC2dwrEtOM48oSkKkFwRFwo7NUscDJ35qQGKHHaAGK6URJ2f2dv4O3WTA0kLvo/J5fpFrtjHoUSczw7LIG9SowhhlO7SNPTmDGaD9s8R6JRGus7Vwm78ITuI/zWem4UKmCNo8W+FTIBKOcbUHM91urLTioBexf+v/dkyC42s9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ba47255448564..b3f2e591fb7e4 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -98,7 +98,8 @@ comma (",").
     │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
+    │ │ │ │ │ │ │ │ │ 0/target_metric,complement,target_value,
+    │ │ │ │ │ │ │ │ │  current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
@@ -493,11 +494,11 @@ to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
 Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
-get the five parameters for the quota auto-tuning goals that specified on the
-:ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Because the kernel does not update
-``current_value``, reading it only makes sense when ``target_metric`` is
+``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
+Users can set and get the six parameters for the quota auto-tuning goals that
+specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
+writing to and reading from each of the files.  Because the kernel does not
+update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
-- 
2.47.3

