Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D5DC79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 10:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9A56B0088; Sun,  6 Sep 2026 06:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A6E6B008A; Sun,  6 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862926B008C; Sun,  6 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4296B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 06:51:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCD248051C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:51:10 +0000 (UTC)
X-FDA: 85183020300.14.2B8A936
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id B9ABB20002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:51:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=MrrdizyY;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of me@linux.beauty designates 165.173.180.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788691869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBoSHGzWKBhSuGS8r2av+j/7qxpuVCAqAJc8a/E78no=;
	b=8GW7N9NMfan11uHgfnV0pR19+xiNe7T2Q1xmfgBSDK40hymgmwtAFSTMQtJXPrg+ajPs5N
	Obl/Ps2d2GusO3WTijO9+vB5oDuVe7ckFYVomkTvQgnwHCx5w9V+xoOaptxs6ynMU7cE0q
	ZFt9XckCqf/IfBQTbp5sAMq2hKvEsdk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=MrrdizyY;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of me@linux.beauty designates 165.173.180.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788691869;
	b=HI4ctYAkNn6j6z66AgrlIDnK7n/89wpvVA8TKJ3fUsPEymt2xMH8X7n2vt5vywNzYED/Jr
	TtIiredekP5d/O3WhUcxsbwvH7E7+l5ngCg1/VioKdryJprPVDu07wIizZllZl/GK5p+TK
	N3hd+ZF7ZUZcbd2x7EoNI1LQjK6U7Rs=
ARC-Seal: i=1; a=rsa-sha256; t=1788691854; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HcHv7QGeAJiTzwkPsLHQtIHDXg+2BOTsRnQz63gL5tKUhmSrb+xsES5fvihLNwX7fRBkNlp/y2e9XWkSUnGxybGoddpScOdoipvFHHNsogDA+nnOriuvZFh9U48Js69etl/8831j0h6BBlQ8Ohq8Jh76aQHkt9reQR+fv2vkO2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788691854; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rBoSHGzWKBhSuGS8r2av+j/7qxpuVCAqAJc8a/E78no=; 
	b=YpSRvGr0ZzH6qrZ+qbq04ewCgD+HEWhzNGG5niJ8ZdAMrLyqvIClzi2u9fd0xcMGYavMl4X4lNM48aeWNvgiCS8+0OnLSmc4E1FhO3heka1AsDUf6fqFCNKOi6haJEK8WO7mWQUYMKKWpc516Mfn/6aW5rukRx+vHQ8vygDeSys=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788691854;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rBoSHGzWKBhSuGS8r2av+j/7qxpuVCAqAJc8a/E78no=;
	b=MrrdizyYZV3Ev0Xkg+kB7NUWS6PN14cITmMXKJ/oZJt2nUbvveceskVWxdh63bKK
	XGTSGzsGkaH5x094cI7PomrPqnxP47UUqtkux5UkkWnBVmwMPqaEkZCLosN/1nK4l0k
	ajHvJCfYOrDP3LmLFinwkZUG/4RlhaUdwQ6aP/5U=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1788691853878565.2585404132941; Sun, 6 Sep 2026 03:50:53 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1788691851513989.1054873609904; Sun, 6 Sep 2026 03:50:51 -0700 (PDT)
Date: Sun, 06 Sep 2026 18:50:51 +0800
From: Li Chen <me@linux.beauty>
To: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Justin Suess" <utilityemal77@gmail.com>,
	"Christian Brauner" <brauner@kernel.org>,
	"Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Andy Lutomirski" <luto@kernel.org>,
	"John Ericson" <mail@johnericson.me>,
	"Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <shuah@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Oleg Nesterov" <oleg@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
	=?UTF-8?Q?=22Micka=C3=ABl_Sala=C3=BCn=22?= <mic@digikod.net>,
	=?UTF-8?Q?=22G=C3=BCnther_Noack=22?= <gnoack@google.com>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, "linux-api" <linux-api@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"audit" <audit@vger.kernel.org>,
	"linux-security-module" <linux-security-module@vger.kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>
Message-ID: <1a07657a8e1.4ebd8dda3414368.7718440407238274005@linux.beauty>
In-Reply-To: <CAGudoHGoOr8rvhSQK+HQp7LmNyE9vP=xTok9eA1ZbV7uaVnMEg@mail.gmail.com>
References: <cover.1784204592.git.me@linux.beauty> <anJE8SfBLtkh6QSa@zenbox> <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty> <CAGudoHGoOr8rvhSQK+HQp7LmNyE9vP=xTok9eA1ZbV7uaVnMEg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: tusjkabwoeg9mjzjwgz6tofrbrq9pw5t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B9ABB20002
X-Rspam-User: 
X-HE-Tag: 1788691868-352558
X-HE-Meta: U2FsdGVkX1+ZMeOI368GQo0TpAFoQTtw9OEqgb/LcIoeUiNO+CEMfQuiktu6FadBstkEFcneJVrvYveyjFnpa4fp4Egsvj5yJdPs6NRl8digcqXWUOAj3HnZSs1w3J5vr1S516DMwyW+uso9K8YTFl99RSHDwAdtiuKR1cs8mLnwfcRJ+oT7rhtG0edaHRj8y9ipPQn3ozL5iy88JSfzHtWOc3VKzCzeaFwtBYNRSefmrx32LshM3/izhRuh9K7jPallhcM6VtjadxAArcGA6NHp7x2bTAxgFck5fSbcefVu9qL4svg9scwVX0KQekMO0EvEAzX995j60afkEtxS4qOiivmUeCzVQKFJgiJAr3ZgIuIl5qHkAAX2WxHHUPBh5bckR7K/y5Us2ao6Rqtbny8SXZHGul+4rMi7oJHLikorCczbxuGGW+LKDMdwkpsp0H/lh1QFbpu2lW35gZmoyNnl7l1E8cO2X04Xz+yXfw8fvpl9wn39+zpCsf1RCMDLiQh/7JPAmvfZzJc5xRj7U47xYb9YourB/hggDEp9fkebPeHhB21iQFG7CIcJTTqAMHqbi/oYpuK6b4TQXealB4bD+zKfNTxr1gqa0f/otIzQnXAB7wGX2MFkhkNt78feKhHHyqm+OfVpTIVYmhwycWcVnSxcH+gSE7qYPmk/tKUIH4w74xqVVj4Qqul8VZxs3RKnPE8T5dyUr67HOj2foCYA+yoD/GUmQ9T2MYCGTh1riuQ49gcrS+wcOW41A4purfggqiunpyrPJnevIlOgBLgUEpXYz65xoLUWPyelgUnL43mO7swN9+vjzAfocFu1Nlrl/vcF21EMHfdw6MQtTnmH8Utn4ZW2rGhFo5zqk+afelVHDwUzZHhkCWTHul6XWSV+fvGlLyuWq+Rl1+ZrPjj8ijmtCLhJ2YeCtAOO7jk0DGwaXcbrgBQ/aP4t+4J69IPKL6fl7eTYaeAashE
 +8BpS+yu
 ScLnDcvGjhP5STElXzhoL2ca3WMs1HDIw2r37amgZ2vK+7ru/LL0Nx7mily9LkSQPRa/+CPF8rclvKG/Ckscn+IsTH80ZKAH1UGhe0QKmboGkdYUlW1ZT8/pmcslGb9ovSjGkOhwNMQyp8q5vRyLCj6ZK1IH/Bp1tq131xcXIGXRyAin6UhAw7tEI8M1p+ve+oE1BbPHtuse7iPkmqPshPoiyiKUb1BVk7ui52woVofg0SgZmZj8Em5D/nTYgBqLzyYNJAO4DHj6tVt0tttWLsHOdS3AqZs9wokVIDpHM19Hu1VBjJvJcMR+x8H9PWjYcGfXF/2xDt2yLkc+gyt0YjcRupwTnyN6nOBugtUJmuDXkJw+DHAX9KkWvIbgK2M07PiRRTEtjm3sDCJM3oyUb1F2YmNusyi+r5PREb+A/3uCXc1JDdA3xtTjuoegmeV7wgGInhjrTSNPnLsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mateusz,

> First and a foremost apologies for radio silence, I got really busy
> with other stuff.

Thanks for making time to write such a detailed reply despite being busy
with other work. Sorry for taking so long to get back to you.

> I don't understand what race is supposed to be addressed either as
> none of the setup depends on the content binary.

You're right that none of the setup depends on an earlier check of
the executable. My earlier reply mixed up two different requirements:
executing whatever a pathname resolves to at exec time, and executing
a particular file selected earlier.

The posted RFC does the former. It stores the pathname without looking
up or inspecting the executable during configuration.

The caller-side race I had in mind was this:

caller                  another process        child
    |                           |                  |
    | inspect file A via path   |                  |
    | configure builder         |                  |
    |                           | replace path     |
    |                           | with file B      |
    | spawn_run()               |                  |
    |                           |      lookup -> B |
    |                           |      exec B      |

This matters if the caller expects the file it inspected to be the
one executed. Opening A first, inspecting it through that fd, and
using the same fd for execution avoids the pathname substitution.
The fd pins the file's identity, not immutable contents.

> Regardless I don't think this is going to fly as it directly shafts
> NUMA setups. What's needed is a path to the binary + the PATH
> envifornment variable or a collection of paths to try out.

I went back to the spawn_template discussion and realized that you had
already raised these NUMA concerns there, including child-side lookup,
PATH search, and target-node allocation. Sorry, I should have connected
your current comment with that earlier explanation.

> At minimum this will allocate a dentry and an inode for usr, bin and
> coolprog itself.
>
> Afterwards any path lookup going through usr in that that container
> will have to fetch memory from a non-local node to traverse it, same
> thing for the bin subdirectory.
>
> This is a self-induced problem when using a fd.

I see how opening the executable in the parent can populate cold
filesystem metadata on the parent's node, even though the child will
run on a different node. Making an executable fd mandatory would
force that early lookup on callers who could otherwise leave it
to the child.

> A well-known exec-heavy workload where this is fine is compilation.
> Any big project will do, to give you one trivial example, make -j
> $BIGNUM modules in the Linux kernel directory.
>
> [...]
>
> The stock kernel with the fork
> + exec machinery is doing a shitty job here, but the new mechanism can
> assure process-specific allocation to come form the target node as
> long as the scheduler does not mess up.

The compilation example helps too, and this matters even without explicit
affinity. Moving lookup into the child does not by itself address the
initial per-task allocations.

> 1. copy in whatever data it needs from userspace
> 2. if no affinity is specified, ask the scheduler: assuming something
> forks now, where is it going to run? the answer would be speculative
> ofc
> 3. to the minimum allocations needed (task_struct etc.) while passing
> the node number from above
> 4. have the newly spawned task handle everything else

I'll look into using the scheduler's speculative placement for those
initial allocations, then leaving the remaining work to the child
where it actually runs.

> In the real world userspace notoriously performs failed execs as it
> makes its way through dirs in provided in PATH, and while you can
> patch select programs all you want, the mechanism will have to account
> for it.
>
> [...]
>
> This in particular means that a failed exec would be very expensive,
> as it would go through task creation and teardown. Meaning the child
> needs to be able to figure out where to binary to execute is. And
> user-visible part has to account for it from the get-go.

Your point about failed execs during PATH search makes sense too.
Creating and tearing down a task for each candidate would be wasteful.
I plan to have libc build a list of candidate paths without doing any
filesystem lookup, and pass that list to the kernel. The child would
apply its setup once, then try the candidates in order, continuing
after recoverable exec failures in the same task.

That keeps PATH parsing in libc and lookup in the child. Relative paths
would stay relative, so they resolve against the child's cwd after file
actions. A single pathname would just be a one-entry list. This needs
interface support, and I'll need to work through the exec cleanup and
error handling to preserve the expected posix_spawnp() behavior.

I'm still unsure whether supporting both modes is a good interface
design. An fd option seems useful for callers that need to execute
the same file they opened earlier, while child-side pathname lookup
would avoid forcing that early lookup on everyone. I'm leaning
towards keeping both, but haven't settled on that yet.

> I'm going to write more after I go through the patchset, should be next week.

Thanks again for taking the time to explain this. I look forward to
your further comments.

Regards,
Li



