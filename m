Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E54606A334
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yj4YR9oH
Received: by kanga.kvack.org (Postfix)
	id 12CEB6B00EF; Mon,  2 Nov 2026 03:54:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF36B05B1; Mon,  2 Nov 2026 03:54:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EF16B05B2; Mon,  2 Nov 2026 03:54:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BECCA6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:54:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03F3A1C46CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:54:36 +0000 (UTC)
X-FDA: 85389568194.01.3230A25
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70EFC14000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:54:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yj4YR9oH;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793609675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYmgVHZ+U4UM0cUUGa/+06lU+eYMGdR+rPvQ4FM59TY=;
	b=t1ucK5+J222gPnxlXLx8C/b7qMNRPp4GbOZlufoJD4ZBcScxL/s7psmiSuyp5fjDvp7wyu
	4mEMpc77pBvvJx89uzIOCkv+UkLHcQjt4NbyMfOYDAtMBlRosw9ePk/GaTJEjhB0TtuWeB
	xop+FxTdAvl05hUA39uh1edBOECZEVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793609675;
	b=3raflCOFSayfzh1OV7aCpap1veHjTvIAyjpcabVA6nLrKYSLfih2dR7wZmms22oOef/uFM
	NHCUcosN1Y1ioaJVUkm49Y5pYxUcA9xmp+2o2UKHdZ5z8OV0cA4Od2lY3jCw2TZwXYs0i6
	DojNlLsExDgML+2CmW5PAwtcwFQ244A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yj4YR9oH;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793609671; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=VYmgVHZ+U4UM0cUUGa/+06lU+eYMGdR+rPvQ4FM59TY=;
	b=yj4YR9oH16T5F0LJttOnUnn//qEucbM7Y95uPVIf+vWmVzrq3o4rZj/ztBIZTKwxDMsPeeum0AkNQo3iPbDd+2+f2MuPX8SraeW271RSyQddyEE8+3ygjkf0CIoZW31B8hsOq4vTrdL66hpswfOklMYkEFs5e/LNltC8XiuKaGI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDwJN9y_1793609661;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XDwJN9y_1793609661 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 16:54:30 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames
Date: Mon,  2 Nov 2026 16:54:19 +0800
Message-ID: <20261102085419.696232-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org>
References: <20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70EFC14000C
X-Stat-Signature: g9jfjj54ee53sew19g76iu3jrwjtxuys
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793609674-854521
X-HE-Meta: U2FsdGVkX19RJhrR8UKLHuOJza+70On+d50RqLUXQkH3f5s4Pdxz49LKmhp3WjN4b/GFVvFQfLz8SfNtQQgCUcrmGVqsMTZ1/mp5SDx0eTarmNXsWeUzEvbZTyi92AFs9scKJMUS2n23Qz2uLzqVc4CoubbueEizAlkugsUnc8qtsRvn5nosJcIBC2HzKdcj3pBO3/4UgO5KY7aQ/qXoYEwU6lkn9q0qDN3VO/ampIIT2f9A3rngNclT9lxL2EnuiJlThRF7Kt1zId7cOSgxCMVtoNks+NCuCNii9WPurkwoVwt9DqTbdgufn18H/8QKLth4zbrWJ7NqQjCqQ2OgK/HlC1vGI8shwYKPox62hGUEkNeeep3OkVkT1INCHkmvTGijUSPS/yGll2MM27b/0lFAMl1+aT31jRL5eCJo1zyoVk2Hnpp22NUEZYsp1EL8utKtDi+Hew51O3HZ8KwnRzLysh03lpc+2CDOxE/XAAUvZgFAqsBiKVV2NXDGCoV7xVCkRoQV4Q/Y97E9J4aUGKqrhEupfC0zWdaIYRfqspW+wg1iwJ9++keKKgay07zGjrG5nIFKCrcri2b9d6cDWJXxQs1qprNP+mdEbomMtjVlgwBGe2qRCtNZbBbwIXeJT9vlt/VhooncYql0XRXO+kP78K7+fVs8yctWcksW0sZhVLek6QkRRBiwep7beHA6g/cB40oS16q1C6WjIGiEewkJ0mOtszuurMFtahNBjMTDgGW/hi4Cl6MKnZ7GNlam1Se9gS9DElUriG0xIqbPJHZsU/S8VUYXJbVKdDNQFq72Nm79HGqjzA372576oYBOrVAwrPrtRjY0M3gjup32N3gzgw95+anyxyP3lLJ/XNeQ+1lbsewKuXdoQf2agaBNBy8tGGCjuY1N5a/59B1mbnHellRl9WD+llUid6MTbCbxxaLQi83f9HebBaTSjBsY9D7WEN8ZoM93jnH7+1C
 M3eDAmO0
 IX4c1HaZZ+ihcFl4nqvdVVRzDHdEn1Vca4oT3WLY0tkhPXqbvJwuJFcY7T67Jz7GDtZ3otS5fZdzsfLmQjvFYKHimfv+7R+Qs7soPJ5MuDMyBr8/EjOcldeYKQjFbC+NJcWbg7BQhciL+ZLZKIZXBbGyhTOD+VScnsm1/gU1C1u02lUY6Hgxv/3WPFoVY55ZyZNcX1U+E+HBmAsx6NrpE8OuXzX9eFulfqiTqW5iaC2CVVYLIw+rN5HcvfAk/64DbAm3PlvvDddJ5eOVOyUkT2bCk9dCoNsLOM9NGwOXe1gFRhMpUuGQ4L8i0XF4Rdbjcwpd75Z+jqw1eDu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMAList opens smaps with universal newline handling and strict decoding.
A carriage return in a mapped filename can split a header into multiple
records, while non-UTF-8 bytes cause UnicodeDecodeError.

Read LF-terminated records and use surrogateescape to preserve filename
bytes.

Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org/
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
This is a follow-up to "tools/mm/thpmaps: fix missing mapping names":
https://lore.kernel.org/linux-mm/20261027074904.3328878-4-tongweilin@linux.alibaba.com/

 tools/mm/thpmaps | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
index a1a9bc30514f..f89568bd499e 100644
--- a/tools/mm/thpmaps
+++ b/tools/mm/thpmaps
@@ -196,7 +196,8 @@ class VMAList:
     # instance to receive VMAs.
     def __init__(self, pid='self', stats=[]):
         self.vmas = []
-        with open(f'/proc/{pid}/smaps', 'r') as file:
+        with open(f'/proc/{pid}/smaps', 'r', newline='\n',
+                  errors='surrogateescape') as file:
             for line in file:
                 elements = line.rstrip('\n').split(maxsplit=5)
                 if '-' in elements[0]:
-- 
2.43.7


