Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082CAF94CB7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 01:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF7B6B0005; Tue, 21 Apr 2026 21:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0466B0088; Tue, 21 Apr 2026 21:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E67F6B0089; Tue, 21 Apr 2026 21:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE0D6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:16:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 763FAC82B1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:16:45 +0000 (UTC)
X-FDA: 84684427170.24.B041A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CA082180005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:16:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=If8Mq5F7;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776820603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0RSxpv1ENe+SXqHVSEBPD56i8FmYqixReCgH6RAPDM=;
	b=aCF/9yoh+odXw75cDira/6Uzrejdoox3r47cakELFI8VrX/Wo1qrOwEOchhzB/4afnOTg3
	1UBLGTV2/eQSHBxqpaj8iMJEL44KlVcx8Nw28eNW9LQrFi9C0waZfPKUWMQkmaPUv9rjZM
	VYUE9372llvCCtShISKNSgEX/NQyY7Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=If8Mq5F7;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776820603; a=rsa-sha256;
	cv=none;
	b=xENGmiM7WAsimySSMmfLvJ+WuaZUWuslFA+3QDAvLTjaBV7KIbpmRTXsm+DP0YudpiHIyl
	LWTt9Xk1Dz6bo3WvURWUVlggZH0oj28MYvt/2nveklPWfZGXbXp00EoRg9OutdJ/KBb+Af
	l2+qferCw4lZrxA6nydk7LNKuAe69A0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2AF74424E;
	Wed, 22 Apr 2026 01:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245A7C2BCB0;
	Wed, 22 Apr 2026 01:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776820602;
	bh=iCRI6Vw9mtwmyRKI+DMnjzpiQb/k2Wa71IR5f/lqDhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=If8Mq5F7eh58pV1iYu+Mb/FJJ7WLmRsqjfIBYcpy4kDo90dfrb+5a8Ovglcz6Btn7
	 yar9YYJucxBLeDZG3SC4fSkrA0tIQZJkYhvPYeUk+zgavB1jpqC973fdZGLil5bFpe
	 09zP56rDorwiGekgO2T10ObEoR9CsIsCkpAVBYneV3slDnbGjnKDq9bqkgxlUZJf+M
	 E8TJxmXcT6xlPtOaLzOdpsFym+5nm2n9waY74DVmIpLzu1o1oZt4CqSQqDOFO9M6te
	 H6KLDoWMJjiPNOmltQ3hJzI3dsbZt7iPZkm+hnWgsTXTBnj4DK09VdO6mHevaIifYk
	 EyCJ/TL441yhA==
Date: Wed, 22 Apr 2026 10:16:40 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] fs/dcache: use rcu_ptr instead of rcu_head for
 external names
Message-ID: <aeghePMTwTof8uzj@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-3-harry@kernel.org>
 <20260421202151.GF3518998@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421202151.GF3518998@ZenIV>
X-Stat-Signature: d16chyet6cntdo9zisdtm9oen9qwb96o
X-Rspamd-Queue-Id: CA082180005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776820603-656942
X-HE-Meta: U2FsdGVkX1/WHQf2fwBvAay58y0zow7grF4p7L3b7hFZ2hrR/JPtu0JrMqNABANiKBL18bI+H84Rmexy8T1QCc2jSCc65Jdw6CyccoKQSinShAQtQc/7wrah4Y+cQXwnDf01ITeDLn/JCRLm8mSWtOSQRazWJSNTsza/90L8DXtK/K83jNJUKKSbK1+vlAXUhMFwDFg3e6ZvksYdwOJeJTIA7LbFlPtZOd753svM6CmoQMaL4hE5tzcLRPDMVFpkReaPzMXzxDT7aIYUqPbCFqGdUCVQtNp//ftJN/qW9soSS1bHjatUkoZP1Ii7MpKsRWb8ocLFnG8aU8b8c8Zu4TsFSfyuGbOfQSYCJ+HAW9SDWmiV6w8tcNFXMvQnvENtCnKQbVHktxDYhMsQWld1aHoyB0d+kwY6P3PqbSdnBh+MX/c20anTeUZW1LVDJ+GHIePEZ6FJ3OC26ghXZEe04GBf4ifKpVQjBnlBgbdARK5gZ43L1j1qhGfsVjATqY9pKWdmb13l2oyUu2S/bCdLmSrnZywXJDNaN32H+8hqovtBjVZevbebLL+7KMLKA4G3LyOm1l6uOX9uX6EKFisv1ZGplRcgUTj6AAq33hTicMuV8CHFbzdGdg/jEhlm3x5NG/INAMLIPl6Ynn+lJFBViWvYPti/lMKomxl5nR9KGdR+kkupChXFFINzgpBItZ+9uv9tQbgtGQN/h9WQpgRK5J7rIlgG5U8tMw/Gp+vXB9jzpSXwZfcE7prFgUYDf47fJLSYWZd0205e7ucKNezYsM9OaBItWF5JlqbYtk4hJ8AqcCoR2g3GZOtHjIjb+yfn1ih65WYjX3ht2bNmFPyWt3mv7X1PNsVeUZISEoraQ/8J1fI+Ra9jQwj54KXMQ/s8p/FuqKkDDWoB1VGX8FGxosamQq/zuzJUvuZ4L6SttY5aj0SYR7oZjqbUdZP2rCK1jOXkx4I4FEhFKbgQul8
 UAOv14Dk
 MpKbWp+Fb8VtDvG2PTPGWL13nIGlC3/s6QWgsMvwiDQu0eEJO/YEVWejKLgiUx7kvJMWTRpxMJN2E9zIuDXxrtCxNU90zglVyJ4jv3kD717vh6pjb32ZHHsonjwiYgxT6X5cYsiVMsZ93pVwabFeNm66yfXF8wr+pEAGbpCsu0i6/rbZbCMasMYIV0xnPbLhP051Y6JgAyHqQpc995vn8zvg808ZUKtSJIhBS0cf7/t/IC0u+sSQWKQlWfkXGV6udzXvbUpE6BgG0OCcB4g/qFvoTuZv+OMxNgBmi2ea55TJnmpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 09:21:51PM +0100, Al Viro wrote:
> On Thu, Apr 16, 2026 at 06:10:16PM +0900, Harry Yoo (Oracle) wrote:
> > When a file name length exceeds 31 (DCACHE_INLINE_LEN-1),
					^ Now I see a typo here

> #ifdef CONFIG_64BIT
> # define DNAME_INLINE_WORDS 5 /* 192 bytes */
> #else
> # ifdef CONFIG_SMP
> #  define DNAME_INLINE_WORDS 9 /* 128 bytes */
> # else
> #  define DNAME_INLINE_WORDS 11 /* 128 bytes */
> # endif
> #endif
> 
> Where do you get that 31 from?

Oh god, I blindly got it from the wrong file:

$ csdef DNAME_INLINE_LEN # my custom alias for cscope
tools/testing/selftests/bpf/progs/find_vma.c DNAME_INLINE_LEN 14 #define DNAME_INLINE_LEN 32
include/linux/dcache.h DNAME_INLINE_LEN 82 #define DNAME_INLINE_LEN (DNAME_INLINE_WORDS*sizeof(unsigned long ))

Thanks for pointing it out.

Should have been 39.
Will fix.

-- 
Cheers,
Harry / Hyeonggon

