Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8F4C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 12:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1296D6B0005; Sun, 28 Jun 2026 08:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9646B0088; Sun, 28 Jun 2026 08:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F323E6B008A; Sun, 28 Jun 2026 08:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D00456B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:37:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A648403BC
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:37:00 +0000 (UTC)
X-FDA: 84929271000.26.B6BC5C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7896840002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:36:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXKkGtWb;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782650218;
	b=Ptp6BHftLU90urqztWXG0rOFMwZwJQyMgkbnlnAGRHeuLBAVWRFXmIiohD9xVaqNaPFTZr
	DiTt8nic5k2Jim1O8qSaU18sBNRqD7Fzl1sfGdBo6YtLqoRaGqvXGXMoWiM8Xdc6QlHXxM
	9RB3LtfbxxmuXWxSeJIn75kIDPtCb0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782650218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztrWcsNGICf3RSZiXTbSvoqRkMmVhds5bTffah+JQMs=;
	b=s7yRCxp3iFT+clXJ5rtkmT6aczP4i1XHYmkHvEwmVuUWlr9bYqkd2g1a3oFAJBkuMvjH2X
	ZjTRy/+UpgsUdW5Q8e5neKeI2Hg4SJaq5j/XzAcFiGihxzftY/G5cTSmSqeq9zYXh+wchq
	29DSpkusAA9OYAHxkI1NYCfpMmars5s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXKkGtWb;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB7096001D;
	Sun, 28 Jun 2026 12:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFE01F000E9;
	Sun, 28 Jun 2026 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782650217;
	bh=ztrWcsNGICf3RSZiXTbSvoqRkMmVhds5bTffah+JQMs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dXKkGtWbbZCPACYW7rD8yxoTgQOXUnMyCnbu4Fek5ZGBj9ZOUQr7J+7+4J2u6bQ6X
	 dR5Hkn2JB4GxOQ/EhPOedNPOqlpXUZ2MCzWea6PxHFxAd3RYElpmuEmkld79wmceW4
	 8HPrCMHtN4SeG5aT4l+kmvmXO+sIB9JErsSkJWHJFQqdTlW4XmVMVgK9tojOCda4C7
	 SyIF0/QcluewB4kHjXB121z51QWT7Ax6FD9yxaz6J3aeT43jttEWrhlHfF/jhb+3bM
	 y6uWVs5iMPfXyUtC4xfEyVEkuurO9t8Qi9rya8gzrtB5jiYbA8Tp6RcJSo0k5GEwO7
	 5yBa+VOIi6+zQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 John Ericson <mail@johnericson.me>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 shuah@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
 linux-mm <linux-mm@kvack.org>, 
 linux-kselftest <linux-kselftest@vger.kernel.org>, 
 LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
 <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
 <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
Date: Sun, 28 Jun 2026 14:36:52 +0200
Message-Id: <20260628-ungeordnet-orgel-stechen-36dd64038541@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1421; i=brauner@kernel.org;
 h=from:subject:message-id; bh=daLM/ZW51+ewMtf63TpPiJQTUHWuDIo2vu2nO/XI3Ug=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5iqbNq5C4vPXSKpuDZvsdF3W7STy/4f4pTP32o87EZ
 +3VThMNOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZiE8HIcDCg6t2lg2qW60Wr
 t/yyWpX/WMi/WP5v+5y1U5e8m33k6y+G/0m5S6SW2AsVcSSd+7ZYL/vUqwkHzreuU+YK/xr1/dG
 0JiYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: uburn1pyrz7amr6s1s5k5hrnzj49xx3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 7896840002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782650218-428673
X-HE-Meta: U2FsdGVkX18Tf69tTcXT/Qm/19CPUXMfUrg2WzcLeHLFaktU85ABgiUjwvEqSnpl/4ml79GCcdmxf51TxuxIFnuqmKcSWu1YK7sjq35fioYx5XcTzS+cBztsH21qE56V6/24Nq/iDY8H2j1RGewm1KljIL52C2rHLKaHbv7pa7fEwXbKEeffnSQWdCKJJBqWokdohMYQcn64NLCrWAOvxDYm0KTj4JRIZRCrKuXb8jgy8o/TE47sPm5pxBi6KrzPb7b5ytodEjzDj8ecVBYUd3E7aFEHf2k9oDOH+5crw1BCxCAVxQq6OW0Xiyx6Aq+5gVpcr9QMFW9gzc4LCExpo1fj53vOTFm1+0r13jVGBB6qU6yWIUEz38x2TkEYTuewhdwZrv2ZEBwoCJlakf/BVTIxFgReS/v5hTw0ZkjEldAHCi2BxRXCl6xBvSx7/69jia8Y2taAqSnR4ZyAo5ZstkdBZ0sY1KSMfG8E4HSdnGcv7HkEZxicBi/qg7sa31lMWFh/qlP75Vzm6W1uT2lwh8t0zEbRidQ2NnNSaZmfjMokUikV4gPJM2P5kERdFlGEjmjklhT5YNJVSWke9gta83bsZHNonrWF2A/0zs5MkPqZwIa36hCCF+s6dSNR8LdkIzuGFy2o7PAA7dFp8PJLqJOKD2pJWrloAf8i6C7q8tmMpW/cEibobVr1Cm7vQkQjhuBfTQJHuOe+IyObjVTtjW3joN5h9mxlN/8xX/FmDsmAe6YdBxH7fuMrIAp+2NyME2foFdmZZque8po1iYtFaAh+0ERkyu/fwS0xMZa/wMAZzVhtjO7F0vRhbL4EeOUAUp20XDX0FZxRSuSqX8or7lLYjplbYer0wOkLSEF/dp8CWG2TR4pO5mYxCM4XlfhoS/cAyC7LUw4fiLvajJNwQzHCFK3isjJ3XCZgw7hMm0ewJy8Mfc9NSKVq03LiVIh1tvebDhguSHV9P27qsJF
 e5a7igOp
 Mu1r88dmCRV14s2I0NInh0DFxINxmp+ZhbnI1+WGScRYPRQHMbRHdLWxbQbDUfG5NvK9W7anxqE7fFBbfTek/SpsenbuhVO/IIsbHcjap8Uo4E6p4gHfiKN6cDClG0jRr5DxzE31SFYE2vBYMzcDirgF1MvItUgu5g2dq65d9s2JOjwctnv8oM68qMUtfWin3liL3Z7xQ4XX9a2quteznT18/EXs/Rzfex9RIRlRrHr189HIZCk+w7sIQtDTK+MJSgOXOcV2KL8M/mDa/l1BWR4vUseDCU1Wk/klXe8zk/Rah4LGYeVRWddcW6Eve2KDZTYD7bSHNMKtV0WQAnq/NQf+o1XJA0zzfrWCIXbV6FXBfxVuinoFy67bOh1+y2ceiiTdu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Ignoring AT_SECURE, LSMs likely will need a say in whether that ORIGIN
> > thing gets honored or not introducing yet another vector where this can
> > be overriden or ignored.
> >
> > Also, we change long-standing kernel behavior which will be very
> > surprising for any userspace that might implicitly rely on the fact that
> > the system loader is used. So even if we were to do something like this
> > it would very likely have to be configurable in some way.
> 
> I think the proposed patch will only change behavior if the
> interpreter path starts with "$ORIGIN"? That wouldn't work on existing
> kernels unless you have a directory literally named "$ORIGIN" in the
> cwd, because "$ORIGIN/..." would be interpreted as a normal relative
> path.

I was thinking:

You download a bunch of $ORIGIN binaries into /woot on a kernel that
doesn't support $ORIGIN. You forget about /woot and update your kernel.
You have no idea that kernel behavior has changed to allow $ORIGIN to
work for the loader. You remember /woot exists and are starting to
execute binaries under the assumption that $ORIGIN is purely a userspace
concept applicable to shared libraries.

/woot came with a malicious loader and it suddenly gets used - if that
happens in a sandbox noboday cares. Now that $ORIGIN works and no
sandbox might be needed I think enabling $ORIGIN might still end up with
funny surprises.


