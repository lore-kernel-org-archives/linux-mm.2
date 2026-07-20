Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C640FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757CE6B0092; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA4E6B0095; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470996B0093; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108C36B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D1BF1406BF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:53 +0000 (UTC)
X-FDA: 85008290346.29.414A444
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD479140009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=t/0CElqHQ3jNsn2WptVMs8x2DZoEpuX8VP6VJuYmV/4=;
	b=3tTm81oEw2VmGMHj0hTslE5JEBrVlyFTmvSppU7qQL1nccrHjf1V43B2ThNTmCsO1goPTY
	HzyojzFqohTHddpLRB/Vul7H/ObLmvgnsUdWxMWci3Zyme3ADXiHypQLSZLcRnym1W4GDT
	vUxAO9lvlFLSAP95a3q1gb+TscMCXlY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531631;
	b=jZgBVusOnfzoBDlFzn2wa7SJFha809MRTHuSnB73/pURGGb7e2Pfyp3emriV5Gnf5r0vwi
	vOAw3KSnBfE6Pw+ZgnfpuWcMv0TMdbCBlU2c7zrzkBLrZbAqhVZ7GQC/rM9AfoI+iW5aVm
	wyot6AdYFMUZIg5sJM/WCA82iKOkBFA=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h3Wv36SdjzKHMTs
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id F167B40539
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgAX4qKnyl1qax5+Bw--.27530S2;
	Mon, 20 Jul 2026 15:13:43 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm, swap: some random fixes and cleanups
Date: Mon, 20 Jul 2026 15:13:38 +0800
Message-Id: <20260720071342.50742-1-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAX4qKnyl1qax5+Bw--.27530S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYz7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD479140009
X-Stat-Signature: 6ttekz5zqpn851txriapeei81co6z866
X-HE-Tag: 1784531629-612253
X-HE-Meta: U2FsdGVkX1+PMVWg8NJEtz5c+p1eEI+MLi5AkIF5tuXNEv7JlQFbGO3EtpePWlI1HKxP1BLzxK1d6DNPQQEu6J3cXUkTS55MvxVbJmDbUfvbKgPAGFwpJ9vi+Z/vB3A2xGQP/1XswHJ0o0JfbbeJMUC0gKdg9nw4Fu4ibPYp2ZET4TaVPCfUTCRJVzb+ZOeAATgT3uHwvGC/TQFNuwYn58SeGDHZWKaGwULp7apJkVp6F4+XBiH+Xp4EiAbd2ADyNVqQVxeYHvgVvwUfSPfm7KbYrSgj7ouRLmYAfqV5YDMgz5UjnDbt09meWbbbSunaHGVngKs2G9tN1rjEUzOov58ytMxulUy+l/UkYOF1VkLrkkbVWIMCdLe/OkyW3dXAHHTV6YARjGfBRq9JJWFHK8muF5T+FVjfZ3QZr1KEzdGzXt2m5sDjmySng18xZjYpnqV6q+9bSma8Om7VZEkobcug2KyfMCdypi6cVwLN6/qnX67xoFCLA1C9PyUxd9PdaJziZvl/UIUa9RZNqxmqgL5RWlvNP9kG2fT/9EhofU+W0hoflE96viPMrodwlOzRfdFXLJ3BEJyiiiQnhs7Yrl0xZPmmZabY8ExcYI9Qz0eXa+YZebnl8KRav9QTunRY17dVQMI7MlbJ4wsxPyq3nkJXFpGW6bbrdXqX8tzDvclWmD+Qn4mXtrC3+GGXWNTTlWW0330uZfO3qkyUxSMAT7YndtG+ebuCM96HS6Vxnn4JzElVy+z7pOKv7c4UaahFJVVlaN1tHVhRrnu8zsnow+6iZBU9jK9A5aV0TJs857S4CuweVngW9JDVp8/ph35whRqlPi8aywEmGpz72r9D9w1AX3iUl8Y+7sPDTYkRJsCpeMdfQ3UjdtHBVRWtC7VybmPWH4Ga3A6FzqUCdbt1oiF3EKwGowO/mEW2iaoKBPk0FGKDsZIZmjZz1WcMWRi+CnCBa8crEdKDv3sc0UE
 iM9/ClP4
 8oJe1SHSi3EqVDdC25dn8kbnzF9ZEtVJR93RrhZokxsYLLk9LJEL+jP7SP/JIx2Agy0HOjDYg4R8mqdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello all,

This series contains some random fixes and cleanups. More details
can be found in respective patches.

Thanks!

Kemeng Shi (4):
  mm, swap: Fix potential NULL dereference when trying a sleep table
    allocation
  mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE
    initialization
  mm, swap: return early from swap_extend_table_try_free() on first
    non-zero entry
  mm, swap: Remove unneeded swap_extend_table_try_free() in
    swap_dup_entries_cluster()

 mm/swapfile.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

-- 
2.36.1


