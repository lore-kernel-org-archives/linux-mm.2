Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD51C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28F56B00FF; Thu, 16 Jul 2026 10:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAAF6B0100; Thu, 16 Jul 2026 10:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF736B0101; Thu, 16 Jul 2026 10:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87F126B00FF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:57:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55C64A0188
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:42:37 +0000 (UTC)
X-FDA: 84994754754.18.D36DBE0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9A438C0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:42:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PJtGmJv0;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MtdjGmLT0xt5rMnJR8PCtisC7e2MD/SvK2a/9gGKrV4=;
	b=GDh1u5kPM7DxqZ5y3GoWz5MzNGjsmr8aU/KN8qk+HMG1q7FWL4Ru8aKZdbekxum7Ap7ZpY
	Yd9EYozfIGm8g3Qr/pXZbDW4jHR3TteE5wjkxCc9zl3L17TjXGG/hbaLdM3CSV0tQ8I6D5
	y5CEoZN3DjuSnCaGAUmZdDekKuNJhpA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PJtGmJv0;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209355;
	b=MO50lXHKDu24Wiuq45Qdgo2J5p9+PFokp3NvD2so17xfSTtvRJmf1R8Kl/0GioUvUnKM1Q
	3HVnfajwqpw3+DB74wxspbhVcQhyIPM5PKCPcouER0wmmdFP6qViY3ds3y9NTQYaO9Ugh1
	fQekLYzR3H9bOAxKCaIwhJE4PmYfwWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=MtdjGmLT0xt5rMnJR8PCtisC7e2MD/SvK2a/9gGKrV4=; b=PJtGmJv0Ua40atV3ewnSERxsNR
	1dsgVmixvVTNJz1outxIMgkjfOP245nFazjkLZwnup7oyutYHdLymiFBtbMrwqmrSRv5vTUn2qPxp
	2MV9oeBGV/lI278BhyA+S+OHXsIePAGd4puaSGcdhwkAsuPgTCtIZYh7az9unRIJC8UCipZuayVdE
	0bh0kTGFF7glT5557VBsTeRD9uCHDfNMlJDZ46Cu1P+qXMjF7zR3SUEeGjjPt49gDo7FqZnwH7Qc5
	N2oH7EOvXZ4XCgxCtIpy5JnY98NgKIOxKFUzNmer9xA19Ev+jLnq6f1hqoPlVx6fSyvXYN2hMQnRi
	BKvdGe0w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkMMB-003rWL-1G;
	Thu, 16 Jul 2026 13:42:31 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 16 Jul 2026 06:42:18 -0700
Subject: [PATCH v2] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
X-B4-Tracking: v=1; b=H4sIALnfWGoC/4XNQQ6CMBBA0as0s2ZMW6SkrLyHYQHtABOlJS0SD
 eHuRi7g9i/e3yFTYsrQiB0SbZw5BmiELgS4qQsjIXtoBGipjTTa4EyzGzHGGV+BA6/4jO5BHit
 ytfXDcC2tgULAkmjg9ynf20LAxHmN6XOONvWr/81NocJOSlVXtjR9aW+eeu7CJaYR2uM4vlSZL
 2C/AAAA
X-Change-ID: 20260626-memcg-oom-uninit-locked-5ec79dff4396
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 SeongJae Park <sj@kernel.org>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2364; i=leitao@debian.org;
 h=from:subject:message-id; bh=2nY+Iq6/8VzBLEajE4I0ru/SZDDX3gzUmQW+p4wy440=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWN/Dp97T9AqgyJAixlK0EYy/uzxI1gYRwj0LV
 T+tPYLJUJ6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaljfwwAKCRA1o5Of/Hh3
 bdhuD/9RMDX/TQB0TIXan2SW1ILowW4i9xqF+dCqiN4JL4VHM4AEK47BfKlg6vXjmvHWsPVlsSI
 gTZsT8p6yiT2O6WDrMh0vVmWLPfj8SygfKSFYxFNKh/hlx8vGSmVBn/RVxvSg8oF7XvsnGNWS1N
 KQpyZH/jJaWwEHJGM9KYco1alSy3l3PJeJdbww6eKHCSbhB4pRK+UW0gduK6ECSRz9VWu85dXui
 GsvqFzfHwqK9aTKwHFGiASNxebqEtZtAQA9xNsAAQE+w7EvtJFq/0lqSOqIL0/txcXttZVrlJKk
 DBSykJyMMIWZ+X3ppCuILAlsx6M9Rh52ml9t79iOm00gRx9kPDsssU3Ny4Fu9/tdDzTtaGKwr/n
 OUUlCDfPV7b+U+OCprmVNH6g51Y1jF0Ow+HmbhtmTrJvgg48oJeysUxw0UT3cyTQLn9lnVI/500
 y/bRiHpdvEVP1s4C8N8ASPupuguJBxk5o4MHH8KUSgz5M+DQdoiZbBh120mxv0dBFmbtNcBbccm
 AzZ35B2x4iRzuxf2wNdXHJYfcjqlufl/7yb2LSrhrQuzSYu1tYxm8/LEFVhNcHTamS+L1ykL7bd
 WXyKRXGq1EapdIudlVAr9c4QQlMtpVRKhqIOiKBlrCQ0K5nWs46upe/0kAFyeMPDs0WC2CGPk4R
 pw0o2O9iMAZEtzw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A438C0003
X-Stat-Signature: h6qt4bb716bd7sz6jghbkekzfrwddqfm
X-HE-Tag: 1784209355-15798
X-HE-Meta: U2FsdGVkX1/yMj9+bPk+VrXLBj5zEudaIfMVdX5ZKWmnQ/bLW+4KatKIQEBYZHxsQ5y+ndaoX4L6PQe2raKT+LVApv1qQR0TyBAzoabe616wYRqFBSfF+auWsO4FxAoFejBhKdxIYRnEMLdl8G8kANbElcsFwWML9Fsh/VZaw8h5QuvkAlP+lE4BI7wE8CQFq+n7jzgKHPgDiUWD8h7M72wjSvH+Un02Ko9pfE9Xa71iVhCGPEiyAAzM/0ZxI9SH6Z3/VDYCEJvie2LlraS3qzyTgAkt9pzpUznx+wDo0FkJimnCbgPsYrhD/hUM5lnqpqmeLVM/Yre3eZK+pyB7Epz8zTmbzE5psWcssVHqyDsIoA4qAQ0P7LZybvwgiCogLroel3y/B1ux6MKuh1AMrXZCWyV31lAwaRlPGexnIxLTA3rOWRihTOXWkVqhHsj0caYszi8vHh63832DioWhRx7IlT2zDctwtm+5G7qz4EIiFG2etfu3/zW2IwmM7gA5rt5/eU5CVDoONPeIDqcw3ObDG+5tJhdbpwU5UBGjgVKyzBuV0R0C36A9jLYfWhnQsUtXwM7jVg4QXHaEY/AgVw8om2YLW6wix99uRa84+/Nm3Yu1osF4hAcmR6rOTRxljZDWtDu9bgxzlm0JG3NHOUOLickOA0lbyxUX6xDtEeyHihL7S/qGyEmpLM299gbc/fc5J/ICM9/p1KWtij05L+x8vW2f7FeHcfqDmZc704s614P2ElvCuGYqI6E16BRxoYOsxQUS4vxcdabrySDHE9cIg+NwI6QVN7lqoOI6c1ozct1fSQlo61ut2cKHObZ8Qr+SRoRs6OXh8X8/emoS9ro7gHUhHcsrVCLlgIMHLj2K+PvkYPd8WAH50H4Xe1vC9LoYvaY6A47bkGiqgnnMISpM1tYLARTC7X9If7i3CxaTNULxBN1Sp/zDnkL+gJuYR7obycBJeWZWuID/6aa
 GQ1sgwpQ
 K762uksqNMWx7LomO5o9QhlmnIL2OYYHCWSd2qq58sKDGFGHbPLfVNRSdbIOpXyccaVTuoglQQoGDSEKZQz0MQQX7F6ySY/O12PYyiDr0QtvwaggAOpA8USj/F9csA7HPAXFyRn/qzWkg7Au6ACfpFDSEYQUJWLlOkV7sc8snvBlP0XQtyg4b3zyorMxJvvvRUz+xWWlXGDlSDCkla+4FT1lkYLrmKwUw2y1tGLC6DERi0LxKx1lhQbPZcBAkLN2S/GkGFY+yMD80Ti00ku6/Py4yJfERq3KkyuPVYfcbwRUc81uzYz8q4Pnvle0VOOLvFRMsAPbS8Ug/Ped1skJhNOhufW9lGHrJ8EHjsfzYkXOR/yO0iQMrZ+zgtcYUuEHadrBbMfJ5Y7HS/A4x7TqgpQWUchsK+47UW4O0TCJHAFoLJ3u9r9zD2mYyQcN7v1UWottePVLf6XWizv/aMRbRy+dA/Sg4AITwtoKElAJoy8maxe8de2mOC1c2DTHhEtUkkjJ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out
there is no OOM lock to take.

Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Cc: stable@vger.kernel.org
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- added the reviews and acks.
- Link to v1: https://lore.kernel.org/r/20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org
---
 mm/memcontrol-v1.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index d3ed5b93290fb..0f703f239c80f 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -101,7 +101,11 @@ static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 

---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260626-memcg-oom-uninit-locked-5ec79dff4396

Best regards,
--  
Breno Leitao <leitao@debian.org>


