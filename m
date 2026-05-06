Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CEFCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4341A6B0005; Wed,  6 May 2026 02:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD4C6B0088; Wed,  6 May 2026 02:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284EE6B008A; Wed,  6 May 2026 02:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1059B6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:27:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4ACC40736
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:27:29 +0000 (UTC)
X-FDA: 84736013418.21.E480F7E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D8341C0008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:27:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778048848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lB9QWt4wLT+4XNkd8ECTAQBmaYEju+vvHzQWOdRwUdU=;
	b=C3H9NbeKr9ycT62RSYC6ZQZlMHY4FY4/clnlu8rgVoPQVCQODDE3gLcMs6+WxiVlasNpPv
	F0nO7POgzMULaZR8QuTh/ndHZrUDuDkZKRRW/i1u8PsiOeNLWyeiWI0Cyjeyu6WaMzkZvS
	7kQzYIQ4jo+hGCBpTQsLfnlZFop7Ajo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778048848; a=rsa-sha256;
	cv=none;
	b=R+Plx56pGv2v9xOzcZS9nofwOEx/YUy/AK0usk99hVgJw3dWDiucMJ8uM9SrWu9IoH5p4D
	E39jxD3QZkQVxjizofGBw/XQb7jR0r28WN78/POf2eqdNuwVA1PQ0Z7nTzlw2XSERlPmh/
	4e9n0+VFnO+NDTUEEUfXeAA0XU+R3Fc=
X-AuditID: a67dfc5b-c2dff70000001609-96-69fadf470ec0
Date: Wed, 6 May 2026 15:27:14 +0900
From: Byungchul Park <byungchul@sk.com>
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: bagasdotme@gmail.com, 2407018371@qq.com, Dai.Ngo@oracle.com,
	Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	ada.coupriediaz@arm.com, adilger.kernel@dilger.ca,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexander.shishkin@linux.intel.com, aliceryhl@google.com,
	amir73il@gmail.com, andi.shyti@kernel.org, andrii@kernel.org,
	anna@kernel.org, arnd@arndb.de, ast@kernel.org,
	baolin.wang@linux.alibaba.com, bigeasy@linutronix.de,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, bp@alien8.de,
	brauner@kernel.org, broonie@kernel.org, bsegall@google.com,
	catalin.marinas@arm.com, chenhuacai@kernel.org,
	chris.p.wilson@intel.com, christian.koenig@amd.com,
	chuck.lever@oracle.com, cl@linux.com, clrkwllms@kernel.org,
	corbet@lwn.net, da.gomez@kernel.org, dakr@kernel.org,
	damien.lemoal@opensource.wdc.com, dan.j.williams@intel.com,
	daniel.vetter@ffwll.ch, dave.hansen@intel.com, david@fromorbit.com,
	dennis@kernel.org, dietmar.eggemann@arm.com, djwong@kernel.org,
	dri-devel@lists.freedesktop.org, duyuyang@gmail.com,
	dwmw@amazon.co.uk, francesco@valla.it, frederic@kernel.org,
	gary@garyguo.net, geert+renesas@glider.be, geert@linux-m68k.org,
	gregkh@linuxfoundation.org, guoweikang.kernel@gmail.com,
	gustavo@padovan.org, gwan-gyeong.mun@intel.com,
	hamohammed.sa@gmail.com, hannes@cmpxchg.org, harry.yoo@oracle.com,
	hch@infradead.org, her0gyugyu@gmail.com, hpa@zytor.com,
	jack@suse.cz, jglisse@redhat.com, jiangshanlai@gmail.com,
	jlayton@kernel.org, joel.granados@kernel.org,
	joel@joelfernandes.org, joelagnelf@nvidia.com,
	johannes.berg@intel.com, josef@toxicpanda.com,
	josh@joshtriplett.org, jpoimboe@kernel.org, juri.lelli@redhat.com,
	kees@kernel.org, kernel-team@lge.com, kernel_team@skhynix.com,
	kevin.brodsky@arm.com, kristina.martsenko@arm.com,
	lillian@star-ark.net, linaro-mm-sig@lists.linaro.org, link@vivo.com,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-i2c@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux@treblig.org, longman@redhat.com, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, luto@kernel.org, mark.rutland@arm.com,
	masahiroy@kernel.org, mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com, max.byungchul.park@gmail.com,
	mcgrof@kernel.org, melissa.srw@gmail.com, mgorman@suse.de,
	mhocko@kernel.org, miguel.ojeda.sandonis@gmail.com,
	minchan@kernel.org, mingo@redhat.com, mjguzik@gmail.com,
	neeraj.upadhyay@kernel.org, neil@brown.name, neilb@ownmail.net,
	netdev@vger.kernel.org, ngupta@vflare.org, ojeda@kernel.org,
	okorniev@redhat.com, oleg@redhat.com, paulmck@kernel.org,
	penberg@kernel.org, peterz@infradead.org, petr.pavlu@suse.com,
	qiang.zhang@linux.dev, rcu@vger.kernel.org,
	richard.weiyang@gmail.com, rientjes@google.com,
	rodrigosiqueiramelo@gmail.com, rostedt@goodmis.org, rppt@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	sashal@kernel.org, shakeel.butt@linux.dev, sj@kernel.org,
	sumit.semwal@linaro.org, surenb@google.com, tglx@linutronix.de,
	thomas.weissschuh@linutronix.de, tim.c.chen@linux.intel.com,
	tj@kernel.org, tmgross@umich.edu, tom@talpey.com,
	torvalds@linux-foundation.org, trondmy@kernel.org, tytso@mit.edu,
	urezki@gmail.com, usamaarif642@gmail.com, vbabka@suse.cz,
	vdavydov.dev@gmail.com, vincent.guittot@linaro.org,
	vschneid@redhat.com, wangfushuai@baidu.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	wsa+renesas@sang-engineering.com, x86@kernel.org,
	yeoreum.yun@arm.com, ysk@kzalloc.com, yunseong.kim@ericsson.com,
	yuzhao@google.com, ziy@nvidia.com
Subject: Re: [PATCH] dept: update documentation function names to match
 implementation
Message-ID: <20260506062714.GA48817@system.software.com>
References: <aTN38kJjBftxnjm9@archie.me>
 <20260428162614.786365-2-yunseong.kim@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428162614.786365-2-yunseong.kim@est.tech>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTdxjF83/v7ez2WsW92GTJOhMNxuvM9mwK0SzEf7IvW5Ysixpds75Z
	OwuYVpmYEbmqBSaEBJEyt3KxNtDiVtzAQlmHsbOiowiDrqIFbJCuqyyskHFfCzHz2y/nOefk
	fHg4Ul7PbOS0mSdFfaZKp2SklDS6pn4bDs5pd1a7N8BwMETDYL6bgsXaNhbuDBVQ4GtpRrBY
	6WEhNvuQhWWXB8GlvkoS/L6fSbDdyCcgcmsKQdVoiIHqcD4Fk5YyBKbxWhaiwQ4ahmb+QmAJ
	LREQcp9H8F19KwORS3/HzVU+BFPhEQQuawED/aGXYWB6koFn3zNgLnDR0HcvgmA84CKgsOE6
	AzdHnCz0RRYI6KmoJ6C2upCAKnsHAbOWJhbGrCYWFkZ3wbI5CzzNT1l4VF5FQUu0lwbv40Ea
	2vJGWHD8cRtBbGCUAFvZOAkXnNMUOJ7Er67AVqg710hBp8tLwYXFGAJP+xgB/c5vGHhsW6bB
	5+6hocdzh4KH98tZ6HXaabg61EfAzEXFfjUufrDIYNu3NoTn5yoR9o39RuJG4xyBb5oesbio
	K8Bis+MUbrWm4IbOMIEDkVTsaDIy2DFVyeK6+QkSl0QHCDw82Ml8kHJIuk8t6rTZon5H2qdS
	jTF4jzrRLDvtqSui89BVaQmScAK/R3g6d555ztGJRjbBFL9JKLnipRPM8JsFv3+WTPB6fovw
	p79kxU/y9teEy3ZNgtfxnwhd57qIBMt4EGJhy0pWzh8S/KEyZlVfK3hrQtRqNkXwL4Xjfi7O
	CuHaEpeQJfw+wXy3aWVCEv+G4P7p17hFGp92VyK0fm0mV3cmC79Y/VQF4k0v1JpeqDX9X2tG
	ZBOSazOzM1Ra3Z7tmpxM7entn2VlOFD8cy25C4fb0ZTvo27Ec0i5RtY+MKuV06psQ05GNxI4
	UrleNj8cl2RqVc4ZUZ91TH9KJxq6kYKjlK/Kds98qZbzn6tOisdF8YSof34lOMnGPHS8eP+7
	x6bTf3/ni/s/Xg4U7UxvPPxDzXulac01r1c8uZL0tuJMS1K/7n3CdODAV6rYNTiroEo3NGjb
	Jrel/8uWGubXHjQ+O2KH3tzkG2fx3g8Hb3cYran24ObdH5er9zoL3zRtufWP42KuJvBWz9bW
	1I6Drzy4/tLR5OKRTVmSNOVEwKukDBrVrhRSb1D9B8vjLae1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe+69u7suVzezekgIWkoWaEUFB5KICLz0hlFQ+KFaemvDt9jM
	MojUtZoWYqvNdFm+LpmapfZiMTUjy8rUypxlTWNZS02xLXE27a6I+nL4nf85PzgfDkMGeEUL
	GWViMq9KlMfLaAkl2b5OExZp9yhX1tmXgk57EnrtDhG8SW+iwO3SUXC5upIGr+mOGHQ1eSJ4
	0p1BQcf1CgR2tw7B+KSJBG39NAVefYsYXBPvxGBIRzBtbUFg7NSTYOtoJKGyLp2A7zemaBh8
	OIbA0O+gIdeZTsGI+RyC/AGTGJyPImHYfl8E0+8/E9D9YwiB2TFFgKPpDAKvMQ6uFtcKunGU
	hsm2dhJyDR0IivrfkzDm7ENQ1/IBgbU8g4ZPObdIeOWYBa/dIzS0Gs7SMNx5mYBvN2gozLCK
	oPP5IIICkx7BwFsrAZqSahqMBTUU1PfdE0Pn4E8Ceo16AipqtoHdPEDBs5xiQjhX2Lq5AEy5
	GkIoXwgwVN0nYMJsEW8wI25cm01xltrbBKd96aW5yiuViJv06BHnKtOQnDZHaB8OjZDcqdqj
	XNmzIZrzuLtoruPjC5Kz/iikuKfFmCvN9BDc+bawqI3RkohYPl6ZwqtWrN8vUWTan1OHK6TH
	WopOidJQmSQL+TGYXYOHv5SKfUyxwTiroFXkY5pdim22CdLHgWwo/mrLon1MslWL8KUqhY/n
	sntww+kGwsdSFrDLaf7tBrDR2OY4R//J5+DWPAf1x12ObVNOYZ8ROAhfm2J8sR8bgQufWn6f
	MI9dgptuPyZykDT/Pzv/Pzv/n12ISAsKVCamJMiV8WvD1XGK1ETlsfCYpIQaJDyl+cTP83eR
	61VkM2IZJPOX3n09oQwQyVPUqQnNCDOkLFA62StE0lh56nFelbRPdSSeVzejIIaSLZBu3s3v
	D2APyZP5OJ4/zKv+TgnGb2Eayhxvv3BhRnj9TpwW4+8fdahsdP2d2YHHnWQfm73Y0di+PTYr
	Wm3VQUNTcs/el3PCzvp9HTvgsVxPWhbeUw/BbxNKZq4ObcuMqR69GNK1qaRUGtW4xQ7+2xT9
	MipkOmj04IwHEbs0RZFabx7eOrYjKLg89LR7X7Znpi2pp1w2NF9GqRXyVctJlVr+C58CT62Q
	AwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D8341C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 3sbmutmr8hybj1joqxdwt3psc1k7qf5z
X-HE-Tag: 1778048845-751528
X-HE-Meta: U2FsdGVkX18LLE1NcAxY7RbEVqXgMMeGODBb48X9grpa9qC4cFEM54/UTUS6xMe/LzcVcFhPBoWw4iCDXQPcqvk1be/Wzfnvy17A6nyx6pDMsQoPhIvq1EzS7/ziyEDmojR3YlxMQG+HK3Aa53TiDzsj/e0tgur5bSIdpGr5xKwB+so0GRaRcrvhAOnrMg3l3K5JOoxa8CYF941PJb7DNAEKZ73T/UAhuEDPwzoJEHP5mPKWSOR9DNUAhgwAqZt/J/TFMMZLb/u2CZAh6RTTgEe5usPRWYcoI6VdLgB/QQlFViTikUdfuvGve2zdx54UelMOra+pxID0qhesygmwQ+zX4ZtuWQ5c9EiJjb3W2Kz1JzF7/LH2qH35LDKKHemzNG1BGaFVn4+e3IPfxmoVYJWP+YL93x2NUVylP0xyBspNGDsynExSMGeUBFdkoj+hDcbayo+AKQozSMeovxBC+FHbv4QrycVIqU4trruBNrD+T+ZOhLQYztwuH3P4/I+ldqeCT1uZW82Nr6J407Cb71w1LxagUPVAMN8Qd7KsuO+zgiQSbx6QfyNpKsUUMQHfcC6HXfx9GyYg6/FjYEVn0xh3xNP5oQ+h3d29hCH6F3E/Tr/5XUgfN47iD+waAxzc28efOO064AfJnbNGrkUPlIE7BWtUZIDcu+S7u2vadjyYu7FjMkb3kcHS6nz/1yo/mpDjq2uhhfyq8JXVGRaQ1GxYAmsj/U/fARQzb5woOuvjrEzubd2UPpKXuue38i3NbpqgD1jDd+/C/lhXD2cUtIdhbXfaQ/1nx3jGOiFI705gTxj+A9fHRLcjXX5mqI8UBrZ9L6WCav5S/Yd6iiE7VxV1qaK6u5LyCdq3wMx4oNjFNnxLFYor5d3UTf6Z5K4G2JaZfgvIeZL8ZSbi7ZjAz+6C4jeZ721uvjVnYdcCG9NF/6hG9iBevPkoT0g36lZq1PQc+T2S15rXPWYR723
 EpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 06:26:15PM +0200, Yunseong Kim wrote:
> Synchronize function names in the documentation with the actual
> implementation to fix naming inconsistencies.

Good catch!  Thanks Yunseong.  I will apply it on the top.

	Byungchul

> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
>  Documentation/dev-tools/dept.rst     | 2 +-
>  Documentation/dev-tools/dept_api.rst | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/dev-tools/dept.rst b/Documentation/dev-tools/dept.rst
> index 333166464543..31b2fe629fab 100644
> --- a/Documentation/dev-tools/dept.rst
> +++ b/Documentation/dev-tools/dept.rst
> @@ -97,7 +97,7 @@ No.  What about the following?
> 
>                            mutex_lock A
>     mutex_lock A <- DEADLOCK
> -                          wait_for_complete B <- DEADLOCK
> +                          wait_for_completion B <- DEADLOCK
>     complete B
>                            mutex_unlock A
>     mutex_unlock A
> diff --git a/Documentation/dev-tools/dept_api.rst b/Documentation/dev-tools/dept_api.rst
> index 409116a62849..74e7b1424ad5 100644
> --- a/Documentation/dev-tools/dept_api.rst
> +++ b/Documentation/dev-tools/dept_api.rst
> @@ -113,7 +113,7 @@ Do not use these APIs directly.  The raw APIs of dept are:
>     dept_stage_wait(map, key, ip, wait_func, time);
>     dept_request_event_wait_commit();
>     dept_clean_stage();
> -   dept_stage_event(task, ip);
> +   dept_ttwu_stage_wait(task, ip);
>     dept_ecxt_enter(map, evt_flags, ip, ecxt_func, evt_func, sub_local);
>     dept_ecxt_holding(map, evt_flags);
>     dept_request_event(map, ext_wgen);
> --
> 2.53.0

