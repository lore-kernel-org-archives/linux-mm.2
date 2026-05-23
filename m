Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709EBCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84356B0096; Sat, 23 May 2026 13:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34FE6B0098; Sat, 23 May 2026 13:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72A46B0099; Sat, 23 May 2026 13:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4E0F6B0096
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:54:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6028D1C0791
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:57 +0000 (UTC)
X-FDA: 84799435434.21.E393C01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE82E80013
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGH8ECXZ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bBokGp6YKVtCQZrud5e4II/4wZ3rZBymvn2I3mXFbw=;
	b=wip2qs8aN7ftXYhaSvybXA/P9Sgj1OZsb8nw8T5lg+DkC6J375tlKemneCa0F9U6XDkPf8
	du/tMJD9+5jlb7jnn5X1y2+hbWT4iZnKhY83fCbbIbws6TXvrXTL7v0PJjEjmOSQ8Ulx3j
	vxAYSD9B4a3RDkB2OemGGsA2TRR7QnY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGH8ECXZ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558895; a=rsa-sha256;
	cv=none;
	b=VjnintZDVLp3r7r3A2aSqJtH+f3mxhDtuj+U3Nq3fw9XcK0C/Nbl6+9geQeH60vWdxfkKn
	bOhkkWMePDCEvRpH1xr/MgsYGoaJNc6WOU07ZhS86Ttyfjl+LlaEZS8NlW3PjCg0/Q/ZNo
	1+sYP2+Kn5tasKJC3pzyv2g/Cg/Bfho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F247544096;
	Sat, 23 May 2026 17:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93D61F000E9;
	Sat, 23 May 2026 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558894;
	bh=7bBokGp6YKVtCQZrud5e4II/4wZ3rZBymvn2I3mXFbw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bGH8ECXZQWVB8xYKDY/34dL7P/Mpormzto6UFwYqmQQ8V7u/iWPHMQTPBkPItAfkE
	 JYt1o4Cf3CN+cxfmAzr35RKANhG/cmjfmksUsM7WzHVSpgYMHN3Gf0ZuFv44EHsQkG
	 5c6hR6iM1fBLLGWl1087vym9DDLVALaOOffnORm0ZfnH5ybe1PyWRRQEeu90AKgoDB
	 Jw2dFEijdb+pzOPHlcGU7KJWjzyYOiV43iwFqaQc4PwA8Zbp5ATunapeAj83YgVs7z
	 H3BqQnMH2LDOG2MvAZHZvX6Ua6wiohmfMIA9nYPkFYfAuWtOIlr24mdMezTmn2Hvz9
	 pETrQg4iAiu/A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:14 +0300
Subject: [PATCH 02/17] proc: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-2-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: z473ai8stfkmtdkaopxp8wnos888ofbn
X-Rspamd-Queue-Id: AE82E80013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779558895-5131
X-HE-Meta: U2FsdGVkX18XRzsZcM7BUsB5C9mneW5LXO+vhLx5j7gBgf/OgWD5we17aeYPQzDs1dXdiuKX0mothvZqel2mhuKiuF61dAGLH23wWBLgsPfmUKfwygipNPkaBYZ2Z3qJ6wG9gIICtgzC1ygQonpMKaTH3XH5obFaj/jqqXJGf4C75+VHg071lxs9SXzjeE78/btu/zmYZo/nEBCu3N6MXXuZxaBev0Nz+3sL0ul1UQ3wbEh8cG7JUwsubUpRZmZlUPybu4TyBrviYuffX73PLBczVplkxYbD93P+SSIZ9/FrLgRpdenBd2W3fq7Isuxj5+QxvgHlJrBUuhTz5B6XTArTwAinMaeIIEolrSGCpjS9Dt7Tenn/+huJ0TKlceNdZi8GWhL8VUXEgwGnoHP7XUGiHAh7YOhiza7HWJSvg7G0jnyyyr9BVHkGGI70ALO2+K6oe/P7u1YDyO25eIJJxEBRfG94Yru3jCqBl4me4oFx9LP2Mx8kip7ba+iEi2w/lkJ+5TH61ZBmQb+lH5lAQgokke4nXkn2OjH8Ek6OtGlm7DEaJjWfQuz2LSLwHH0mTfOt2gYBQn+8cPAyscafkRISce9SbLwQiiF1nvH1g1/Yd/i+i+z5mCnTbD/Nr5saYNKzQhs8MO4ujA5e/ydXOE/FStwq6lAsW7BJM91bU6eoAOyrKj7pAY6A8bLgtcf2OYeQAbCrn8u8aNy4rfBgmXI67POcWYwlmxrCqSZNhKLOHwP8gS5cFyOOIkxJiAvsAy1wL6jHj8E2OrCEToL44YmxxaRSUxWtSaUG374fniuTgyjtyuOQWOjumTxGCaXoyrbigqFszkD2m13I44LCvr5MG9KcILKfCclZuBOkNrY2VbqZt/tcJp7EK7DryfeXjVEw1zu0+XenkZJlram7Lpvok5g0Jqo3BLblmnn6LFiJQFiT9tF1y+6JouBTQUICXAj0p4y0Nu4XiZrmQCV
 2op/FNRx
 7rhCPBUcMQ81/3mLegf4E7lyXItHIlg1SkVjlPqpbw6goURKDiOJ0PnhI/EF0MhxicjtoKSuFzE6cxyadHF/a5451YJxlGc3ZdBfUA1TvFoDMrTbbAMC8pfjvXlfdW8pGtLYybk/MOGHXagOm8EBd6EVPjfcJ0HIdQYTzhq3QGfDlW8tUU6FL+AGPc5sjvvK4t54i7gyjMfT7B/FptyTzIv+C89PLZpBC4YzZ0jkWYu8+rsTPqwfNSJQO4TRZPo0hxH88TE6R8KhAuCALIlO912JVzDsQiY/m2jIn8lA3LQC2Rb8HPWr1H0bJbaM3YVVHfQ0wjcl5N3nNGy2A/IEbljd9G6MaJRHORFqJAxVIPhATLSLc2hVPpE6Vr+vBBIcv7CLfZawU4qOrnDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few functions in fs/proc/base.c use __get_free_page() to allocate a
temporary buffer.

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/proc/base.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d9acfa89c894..e129dc509b79 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -261,7 +261,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
 	if (pos >= PAGE_SIZE)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -284,7 +284,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
 			ret = len;
 		}
 	}
-	free_page((unsigned long)page);
+	kfree(page);
 	return ret;
 }
 
@@ -347,7 +347,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 	if (count > arg_end - pos)
 		count = arg_end - pos;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -371,7 +371,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 		count -= got;
 	}
 
-	free_page((unsigned long)page);
+	kfree(page);
 	return len;
 }
 
@@ -908,7 +908,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	if (!mm)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -949,7 +949,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 
 	mmput(mm);
 free:
-	free_page((unsigned long) page);
+	kfree(page);
 	return copied;
 }
 
@@ -1016,7 +1016,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!mm || !mm->env_end)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1062,7 +1062,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	mmput(mm);
 
 free:
-	free_page((unsigned long) page);
+	kfree(page);
 	return ret;
 }
 

-- 
2.53.0


