Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0C1606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=D0F9depx
Received: by kanga.kvack.org (Postfix)
	id D86686B05BD; Sun,  1 Nov 2026 12:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37286B05BE; Sun,  1 Nov 2026 12:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D646B05BF; Sun,  1 Nov 2026 12:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A02F26B05BD
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:08:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33DAA1A0A04
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:08:35 +0000 (UTC)
X-FDA: 85387184190.08.B866455
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3BC84100005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:08:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=D0F9depx;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf14.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I21QGyvLYuqiW8efrWEKXCzyX85q7lTtLZbUXjSxMZg=;
	b=Sjb46oocN29egTjmq4VbwvAhrnccFVpOaEtzcNFB4Umqu1eE4cslrhWNiOKo/CVdLGWVmd
	5WvLnjuYrFr9xAb26mIgQi7QPCBLXEGSjffDAWXBsrahMtXxquP53s+fre92tMzne5nKxh
	drBDM6CKH+d1lJIAwGCU0qAB3y4RE4I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=D0F9depx;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf14.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793552913;
	b=m+yJqiYLXkGva1JnCsGv5W2qqcVIp8TKGviz8oN1ukyFE1VgberLIjYDJR2qWaXQPxjG3t
	t404xfeGMI0ijl/bu0MaHmvBo9QX+4xCKotZ1jLy3r9Gn4jRBs6/1kZaqq/Sy+GTDDAUgP
	+b+T5Gu2Hz+rWzfqfsj7dw7lcWgu5a0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1793552910; bh=5+DQMvP1EuvF1C06xt4Si4q5kFFWytIZId09erO2zY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D0F9depxyP1choXEsj3BLO+NFgOq27OlvisF1QlY1PNNWnc7ogRn0bEN29rJhoKGM
	 jOOl9z3hmbj8aoUJVK23QJOXi2oj19nHuluRSahgoqlbs0Y43T8lUZljgJJ6lR12JX
	 4YBJ2Fz0f9xAqDCm8LKx4b6+DwAH/IH6CXX9Pc1FCBliOau8jiH4nnkD63i9uym/zP
	 iElzlzfONWJYBHnacCC46WmsfSeffGVRifc/2gCg0YPYSTimDeh+UMCSxg3yz0nTIm
	 0p/Q6rQydT5EewIWUQZFbVIBbLoYLwbsBmjHgeM5QGWbBZK0iojXYKzdLKuf/Uir9d
	 uAPnglYflHjlw==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id E8010553; Sun,  1 Nov 2026 11:08:30 -0600 (CST)
Date: Sun, 1 Nov 2026 11:08:30 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] userns: keep the exec securebits
Message-ID: <audyDljs8nV8vA6h@hallyn.com>
References: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
X-Rspamd-Queue-Id: 3BC84100005
X-Rspam-User: 
X-Stat-Signature: 3hbziwahpat5wezqw8dwesjme3m3j9z3
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793552913-313395
X-HE-Meta: U2FsdGVkX18JZ0xtX1HGYFRwnKFs+AbYSUt9fZ2eaG0QxPohWXl8VtpfMOnHVE9PRPCb0ScN1Mq1uWoooE9/BTGfEwT+x8BJ6Nm5DCie+4F8ihDG2uO+SsGhfusIZuSogKzcgePL6R88BClyI34vsBg3INy6P9YRjPA+XqChVqj85ADDY3Hha/VKRG9zFdLKqdfRETAS+fiVRWGG1sworeAbFnJ4GnXtWGdmMYd+/kXqP2ZR2mzAvA3ZvzKOOa/lqfqqK/PPIydS/AIqF/8WpSwWLMn6EduXu6cXnE1nby38qibc+po15Ha1RlGH+SsfRbLRDuH6kcbqvce3HvUjsu+GxJrSg773X3GtiIZKk/ZTUNi5nJMyC6L3i2nDLxZz/gf9/waDQjKz08IbOBbaGFTfOOUk+wbr9Cke5rjPwf3E1loleWe/qm1yjjNAeMUKVUL091Ska/1QXcoWiiBa7G+a3GFh5LmifLcBBrtBPDc6ONofk5U32E5ZLeIkmZ9q0Zg7MFfEobUKX4AMMIAOasrnWs9HeR1BImj+kjgVOQFiVVQpX86v8yH9V5JgikyFiNlA+Hnr16Qq7Kt9sWD0KCo4sEZVy7V+iHTGooaFvdj9uDr6Kv68K8CyEygmQ6jfw0THQTkJjqXmqUk3yOkUG0DWzsGlstUhBpKiXhjv04SjEUznA7Xm5YaEqzHlZFPMI1s7sRLIgDH3BvqPB/e89geeUXUzmzm79R85WuJR6Hx550U1hhraut/O5DJTIKOUS5l3pkSpmK/TqT4G8G9Og/UyWPg9uZrtNHWdMYMGIG4KofZ4CZrI1TQx6X8uPbKvI18TDaz17vmEhUOSLtQUKihdzZdJWX1iNqatOdoRHC3tjie6YnzYYolpm3okWe9O9YTE7HKe95QIsvd/tgAapfb7BUz6rXkBK5yWXJDfkjuK3sfX3+sXCiLVmc8LFP2JLPzNHpw+CGBBLjA8Td0
 JO9O9bNX
 qizi7l7UHX/vxzqZXGDPWe7hKnxsfpDzJwX+57VHMyZdHyPMfsQIVCyH/orbQRF3rz+VhTEL0Xwco0NDni7sv4E9VE7S5+BPsXEc6zTLU/Cxj5ypI3zthDh9OiCjuzDEWzO4FJuvGJ8TNnBAfL0/838/nMYc9KojYR+YP6AKXSP/i1z1a4Kv91am4ycprwmvOj9PB46QOnVnaIEdCgjcDt5otL/P44RbZunimtlVvRsTe+W6E4W/0rc8nDudwthizWTNGk4Q+H4++ikI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:53:28PM +0100, Christian Brauner wrote:
> The exec securebits are meant to be set and locked by a service manager
> so that nothing below it can turn them off again. But creating a user
> namespace resets all securebits, locks included. So anyone who may
> create a user namespace can shed them with a single
> unshare(CLONE_NEWUSER), and joining one with setns() does the same.
> That's pretty much everyone.
> 
> systemd gains a SecureBits= setting for the service manager itself. It
> sets and locks the exec bits for everything it starts, so interpreters
> that support AT_EXECVE_CHECK enforce the system's execution policy for
> their scripts. With the reset "unshare -U python3 /tmp/x.py" gets
> around all of that.
> 
> The other securebits are about how capabilities are computed and
> resetting them in a new user namespace is fine. The exec bits grant
> nothing. They're restrictions a task placed on itself, like
> no_new_privs, which a user namespace doesn't drop either. So keep them
> and their locks and keep resetting the rest.
> 
> I also keep the exec bits that aren't locked. fork() and execve()
> preserve them and the task can clear them itself anyway, so dropping
> them on unshare() would just be inconsistent.
> 
> The new selftests fail on mainline and pass with the fix. I think this
> wants to go to stable, otherwise the locks don't mean much on any kernel
> that has these bits.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

thanks, makes sense to me.

Reviewed-by: Serge Hallyn <serge@hallyn.com>

for both.

> ---
> Christian Brauner (2):
>       userns: don't drop the exec securebits
>       selftests/exec: check that user namespaces keep the exec securebits
> 
>  Documentation/userspace-api/check_exec.rst |  4 ++
>  kernel/user_namespace.c                    |  5 +-
>  tools/testing/selftests/exec/check-exec.c  | 83 ++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 1 deletion(-)
> ---
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
> change-id: 20261026-work-securebits-userns-6070b18a9cda

