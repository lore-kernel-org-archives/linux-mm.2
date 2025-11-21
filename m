Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF71CFA47A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F406B000E; Fri, 21 Nov 2025 02:15:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6167D6B0010; Fri, 21 Nov 2025 02:15:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553256B002C; Fri, 21 Nov 2025 02:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 478F26B000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:15:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C226A4EC40
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:15:04 +0000 (UTC)
X-FDA: 84133752528.20.1BF8B67
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59B3E140007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:15:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="nnE58/jB";
	spf=pass (imf26.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763709303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIXqlDrtPhMmpwTQ8EsYrSQr66/V/dN5uVlu5UxsaNM=;
	b=WTfaAv7QkYnHF6Ew7Mm6EO1r2Mem81HlfsX3UpA38ywGUYBkYUJ2LbMh48xYND3Mxa6BB8
	PPLyAb2uz3s5bLVVtjW4H7Htd7HHbjPoms3leDZjk1xtdDRfFxXNOKevH130aplzX2UBZv
	7xYEddGXjcXPUX7S0nVyQhChEKI6eSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="nnE58/jB";
	spf=pass (imf26.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763709303; a=rsa-sha256;
	cv=none;
	b=UYM+MVV7ZOWKWa8SWODH7cIYNtthVq3dzFyy71PZLiHQceuTAOqY1PC3oJ5QQjLmqp5B73
	dttGHvkg29Qa1X+UW7p/08NNl0aN5XQ7Ll3D4vojZFn+KCPq2MlD3JpHskbLdNsNC/+Ce7
	OuT6HT8wa7Eh7c3GIOgnU+bAR64E8l4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763709298;
	bh=XIXqlDrtPhMmpwTQ8EsYrSQr66/V/dN5uVlu5UxsaNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnE58/jByThWTH2D861d1sosQUHp7Hp0zPJcoytFsQ1wpTsHHYbhx9w+7bbxaeA6y
	 8oF+JvZ+gN8e+kgg/Nn+alGzx7EFhowK/07fdvSaFrhsRRXeG8Lz6WArEnW23EA9/W
	 KHofrWF2AFAZyJ8dkuLaKmZZTGuxw0khd4B+wpaA=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 3B700E79; Fri, 21 Nov 2025 15:14:55 +0800
X-QQ-mid: xmsmtpt1763709295th2m2vzwp
Message-ID: <tencent_301571E78C8FB8CE9FE3E5857DC174E5150A@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNPRRIugqvnJvF10UIOocD22inf83ArdpNR3mPDYc8qMEZdSLIt5i
	 HYY8enqE8S7hNKhgtFBoU9hG0S8U5u/+MhiQVr7Who95bvGPbyKPwqC52CLEmw4JDWIo2xP7ugdn
	 i5c9kO7+crS2kpqxHnLvzlWN7f1AQPLUmYFNOC6pytDhuCMCbCFHA/TyN2Wn21I5wNYundIEcKn/
	 cuvzoVC5ixOoQQ4+ehdxcbLPM/QkFSWOp+g6vAKOPdu9nVW78bnRZ1nDidZKATWohBkxuexsKH8n
	 79b5TUg+i79H0nivXfjzQfaji8l4HxSAAbol03QEWJhgBAYSe+gqI7djAuQhSl3Orw6+yGKw1gYZ
	 7QEVPv17cf7JUSXVH4Rx0L4l5MTdbz29F7V8BAGOBF9fBOKnug3L2MKDvOr/FAwsYUEHoSiu8ipK
	 62tvALA6dHLi7/tTGlD7/896pXYUo23WljoosgaPedPDJ7mjKqfAOXO+prZnihMdspjf5Q9A++VJ
	 +LF0C90ksdFh9WerO0/y6WlZHGHphmEqrvu1tx/g44OFF2LiBjtTDk/ncJhk5OTgKeLKFs2ICxfO
	 hjIMoLiMK4zp6aY17z8kVZm3Yh2IZlmjRo9eYSauT95tjy5sxBlxqQnzWCybT/ZkmAshKFBoGLQl
	 4UGrGm9PX6g8sByc7K93xlNvRt6sHllYqC7OeSgm5HDxaq/v+Mebsuci0U5aRocFvQLNHmphXZqT
	 u6yOaMETAi1vjOGbIBZugN07h50Y1zPOuleEDV+rYF+eAV+iBas5wqlyoK+U8qlwNLpAWyaaLK/4
	 xkFn+VYWpji4WfKSiaGS4DDCTIK7mQtfCLDt0cWWYUGEpnbHw0Lt7kY/303zFZO8DhTvX9zS/zGQ
	 xyv/nNjY3Rb/yeTh1OxOJYRu59wo/syYZxyjSYYx1R7LeqJrR6S9LUl95cFlJV2D7l9Wsi0Y9Ehs
	 nceYyjuEe4jZ2PBnEDJlHY2IPm1a4UM6XznX2ZvgJPUGzZvmsUDMqYrQwumTND6jEqKWz7z042we
	 Hg0bNfuV7bCLKzQ6Re0e6er86/QKtxiSuyGXtN4SQCI3BJMwe+RNVql59Wmho=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 15:14:54 +0800
X-OQ-MSGID: <20251121071454.2999571-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 59B3E140007
X-Stat-Signature: bsx4st3yk3ic6cjeqbw1nqsdq3pnu954
X-Rspam-User: 
X-HE-Tag: 1763709301-728142
X-HE-Meta: U2FsdGVkX1/JfqBUtgvvRrWXIMwWD2sVmZDp/9F4EAqr0rzLOLdlBNMDtFP/Jil9y0clxzCvVjGSqH2eeh+KGqScWRHo1RtqaPQrE8RvJ2rZcEOsOKyfUxUMQomoaQ+D0ufGZi106lJMr2yneDEDZo4MoAPvWSpDxd5GeezOmt/bkhS6Mx5iyOj9cWpYaJTuN/EX48AC14SY6m31Vb9qbus3Znz3Ok483OSMUh/DkpVZO1/zMx4e0PXV3smK2hvyl8eqh/E/unu03CqdTgMeGGqvv8bMlm/NOsDFQoWKM+Yt5PIX3+Li52mobvQXaJ5QAau0a2d1DCIY2Rc7wIM0WYnMqdj75OctpoZB0czy+1MXci1EIptHCSNo7w8OS89PngED1ZPh3KM4sCsB0U/O5R13Xd9wlHVUBe2F9DniJeRJbeSRSd2+xNfg+y5mBCipkc4Z3SCzfD+X1bYGwSTQz8Sp4EL/RHFGWFSm2+tvQIyCBfskGrQfdsU1r9UgpCQ2xKYU6qyFi2lxStUi0wc6txv9O06GbE2Hm398CsQyTvAl0GRjSyU42Z8aLD1Q5kDsc3zOnuyG+ypFj79dogM+ir5rgiXh+rZvFoofxqxF+ER62JCwCJRcAnisUaZPdUr6HGAWKCpLZYdpEQ/cG3YnJn7Thi5DBXghrY9XBVgjX0XiY1UxTOtzIOWc8fZ+skX9eh2NBYDacgBLCPbIbOr2YzQSUPx9LSm6aP9j3eCGYbns1geY4rEWiKhUB1Jnn8aY0OUm6vgaHyvsfLiOzdVwMOPeDlIplIQtVbwGwr5fx+NtNkOK+EwhlSZmvdAK4ilh4WELWgSNtZCaP31sHPgEZ73EctFJ8U8e98B6krZCwFoyAMDFuzsf5WZ3Fower6HJoOFFrgN3li6TIVAUYWcGcX2PGNquUb9RR+Ylosppeu+WZ7xIIj7IMNHj05boARRYQJT9d6JIKszwfdVO6E2
 AXcQG3AD
 4LGagNVncfssKHNzHPCMHoy9y+YqrTUD2Ej+04uXCd8omHPw+6t0njLOia3CHLhmVYKAoVlqAETlQG9PqxJY/KJHqR8StvDJWsxqGI70kusCGw1fPapb0CfbDW0hwD1e795ZmSdA3n4DZHUUjE4vS+7R2ZAhBojes5cxiJz7jKbI8I5i8a8mMT/wHbuOmyFju6yFv+MlYMQ3yMH7ntlHjki4B/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 00:21:20 +0900, Sergey Senozhatsky wrote:
> This is a different approach compared to [1].  Instead of
> using blk plug API to batch writeback bios, we just keep
> submitting them and track available of done/idle requests
> (we still use a pool of requests, to put a constraint on
> memory usage).  The intuition is that blk plug API is good
> for sequential IO patterns, but zram writeback is more
> likely to use random IO patterns.

> I only did minimal testing so far (in a VM).  More testing
> (on real H/W) is needed, any help is highly appreciated.

I conducted a test on an NVMe host. When all requests were random,
this fix was indeed a bit faster than the previous one.

before:
real	0m0.261s
user	0m0.000s
sys	0m0.243s

real	0m0.260s
user	0m0.000s
sys	0m0.244s

real	0m0.259s
user	0m0.000s
sys	0m0.243s

after:
real	0m0.322s
user	0m0.000s
sys	0m0.214s

real	0m0.326s
user	0m0.000s
sys	0m0.206s

real	0m0.325s
user	0m0.000s
sys	0m0.215s

This result is something to be happy about. However, I'm also quite
curious about the test results on devices like UFS, which have
relatively less internal memory.


