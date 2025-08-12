Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92FFCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5B08E00F0; Tue, 12 Aug 2025 03:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476D38E00E4; Tue, 12 Aug 2025 03:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C958E00F0; Tue, 12 Aug 2025 03:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25AA58E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:46:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33DC1160224
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:46:46 +0000 (UTC)
X-FDA: 83767323612.26.26CE1B5
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60F091C000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:46:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3Y_GaaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3Y_GaaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754984804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Umk1YoadKdpa6fyzaimwqq35auuAfEV1rwGDtpJveWA=;
	b=vu+XA8+fI6MQalztor8JxmRR2ZC/erMRI+I1R/X0PMXkmVmuJ19fQvz6x4dUtTtCGUazuk
	eEV7CPQ/d5aY8G1TfN3+YWaRP4y5h7i7OJrAQ7d6uTXP601nVpJoLWbmn+34DuW5KOyqyP
	BG2zu3B+WaewPSLioryWfSfkHaGDBkM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3Y_GaaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.71 as permitted sender) smtp.mailfrom=3Y_GaaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754984804; a=rsa-sha256;
	cv=none;
	b=BgpfWHbIpoL2S638YYtclYjcSCadUWeuTPkSLtr/VHtN6lebrtlrCot17V0P35nngMqqWn
	TL1cjAXGvX1ih3Ay3qxOENGUBuf0bsh8MISBsQG1BF8Uu8MspypuoF92MQl9R72Q8i8wjK
	NFzjeYLeHje1fjjnnt65Xw/x9DVfCLg=
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-881878af906so1022876539f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984803; x=1755589603;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Umk1YoadKdpa6fyzaimwqq35auuAfEV1rwGDtpJveWA=;
        b=AQTOoDL/gQpQb2qpQ3Dh4TeFGgqG4CXmMRMuhqeU5vQZgE5FuVl/mGAGYZ4BIzXx3n
         /Sk84c7YmzaX8BS5aj8WLVnWDwUAqnvIH8zEnQIEgezz8/Y4gO9zkSnHb0ULnx8N3idM
         gAxw1WemLnowjEQoP9tU9vIT+zUNf8sP/sPKukPgUlll2W/8kPGTjcTHbu5XcplFnp1w
         cQnf7xqgI1KhXcvPOJWEyTw86RnCqbWyFy08cS2fKnjwygDoCsAaT+TBOpheunGQe68u
         KDAVHU9LjeyVeSXgKjEeekQKNFpAdwOjAT5KBsFVtq9h9wMqsX7ETD4akp23X/bNW7O3
         e6gg==
X-Forwarded-Encrypted: i=1; AJvYcCW2gSIIGbby2oyRDVaV/Mw/WSx4K5LHZkiRVEmW4o4cR1tCD8WVefnVDoNJPtuLKIxUa/gUrIXBgg==@kvack.org
X-Gm-Message-State: AOJu0Yz99ZP9aoZo2ZNXpvcFaUd+DccTqdn6+Yg+zpiYZ/XyU4WZWXBf
	OwXgXdUwz/YWXFwol8vcZSVomcv6XIQ2hha0LjpHTU6WsSh7ejzKal9nd6eZeHC7e3BGbw6uMrV
	LyTZRtIu2AQIw3r5bLADbaJZCLbB/pqkyhIcu/LTO188gObKIuAZMPsAeNVQ=
X-Google-Smtp-Source: AGHT+IGMO5NHQ7t/8SdMDmkMxxHOO+f+f98qggqnhfBOuHrFo4tBxoy7lI5+nUzI68F7dY4bFrEZVQmeL1OqGTmyoq+dADo+nkMr
MIME-Version: 1.0
X-Received: by 2002:a05:6602:7187:b0:881:9412:c917 with SMTP id
 ca18e2360f4ac-8841bcc009bmr501638939f.0.1754984803514; Tue, 12 Aug 2025
 00:46:43 -0700 (PDT)
Date: Tue, 12 Aug 2025 00:46:43 -0700
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689af163.050a0220.7f033.0112.GAE@google.com>
Subject: [syzbot ci] Re: net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
From: syzbot ci <syzbot+cic0c8bc3087cfc855@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, almasrymina@google.com, cgroups@vger.kernel.org, 
	davem@davemloft.net, edumazet@google.com, geliang@kernel.org, 
	hannes@cmpxchg.org, horms@kernel.org, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, linux-mm@kvack.org, martineau@kernel.org, 
	matttbe@kernel.org, mhocko@kernel.org, mkoutny@suse.com, 
	mptcp@lists.linux.dev, muchun.song@linux.dev, ncardwell@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, tj@kernel.org, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 60F091C000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 99qthzqhcrp3c9ujubb8khjzjrdg8eaq
X-HE-Tag: 1754984804-650947
X-HE-Meta: U2FsdGVkX19H2X/sy+ULbi4sDZWkLjMWNxbcfH95FzEwAs6PR5jUrTiRR7gzMgQaKhf/NtDftI7leJsqSVzBHQWJ7Ux3YGlpMG3u4+0u77n1ZGmk0kAg2rAQD1sWixS7WUyTFzXpyaUE8/IUT5SHx5i9itXW9i7lOd5lLZ6mGxg+YhuwPpOAHMvrIjtlLdoOU6CGbdSDuDPl9MYKqAPlT1hT/dQwSuquvmpCXfo2mQTGL0mLGlAPrjPIuis0fmfQBHING6FX+o9dtl7AE92hKGUblJZslq/Cx2fsQK3efC+BN/mrrlYEgYD4HcHAnyg0RpnocLNQKdc+9hfNlqYW2EvujxE7Ebc48WOhEnhJj8ofyUo1RJktYVoEBhfv0dK2RXrVP+dgTFEaUkaylpqFV0PL0FL4RkmEoXUuGOjlRQwmJN0CaugFnd7alvSBHh6Z6W2BFEG5mk9iChwOuqFtm9MmieUvsT2pnvxZRp2zd8gqkrDV6Md1Rf68MvsggonhA/ZLblrK2ttZPNOK6CQogVSk39p0qYHFkcp7tFg/+G21s54gqZr3vnxtwyY7s1OZIemp+0JhzUOZxIJzxA+MSk7hMtZ3t3BUzTSUVIFmQJtJMSVCMvGvqR+jPkE1/swKm9FFGPmNSxlZiPZnhEPNpb+Js+Jb6UHOii484DNocRUC8HIF6wzcP2sKN60wUBdT8f3PwRJ8V0iWpq7vSNrMYsbHKGZI9YzyVYMuqGsUtEC4X6crikYs8vSY1bAxQBB6m2pzvmrxuVrJ71xf+SjkhltitNOWZX9DNhuZFEKsp2/KZr9cemVvsyht6RCYJWJswl+nbuyHw8Y8neOkyhjMnYbICeqlEg6SLRP5D0y2DXdQPmZq/vl5Fxl1h6h3JmTEAk3aZfzHURYZhGM7A66F9cU0rJsG4lU+lgw1IGFb4BBj9Y6k04twUYP2mQlfNywJkCKOqBAk6jkXUde7uNf
 dBkHgbLo
 N+ltUsJujcb846u1rMCp+GHNfQG0OtXp4OHIbOK/X8z1/6z/kscQv2Wa0iyXCJbwzRM56gWJg8JyoHVeO8MD/KVArPuwixZLWfJoU6vNTPGkGXF0ONYDx5SX71/ze7znv21OJW0aJu1y5Kd4czivvol6sJBKwMC66Bg+ctaqLAY8hXqP/21HZ3KAtoc3F5RkBFa0eoMJY+Eg3hKIdKmZm58F8rDmNTx+KNvkMP9j8vCRMZzkRKXKnm36nP9DO899XFcyP5jV2Ei8EKId5cxVVgfds2F5ZSerGCRGQHCPguC3nv6Jo8/RaLqU25QROYLVHDZH0qVK391pUunajFIL7U7uDorHDN/y2Jirjev1ticdubegBXVBQpk80V7YqkT4tYUbhZjvAE3bedraYTQ9xYOhMHalTlgkkkSE/wvLkPD2T9y+9ccQK1lZHYs5E0wlN9bHdoNiPXP+OF6oXT1ioE/Fy9uswijNIen1UiJEQVQbxXY+vD7dZLYGPG6LVTpIN7HVISfGGanpP9lucUB5XIirxpA6a8pIzsJHqeKlSbTaxLmNvXQalzV6czgHAKJD3Zm6Co0klinl1gyC57Xrv52J3PA8gppWX3J/Nxo5oWE3ZSnPPCrqjIDA80TRdAqrK3H9I6C6Xrvnxm/R/kR9MROTbxi3/99GLDgi/Zi+3iXXiFgfqXjGNN4iA4CFwSIEqK5k8FL4hlkF+JAB4bJdj0Zjzzu81iqlcxK/U1+aFOg9jxmWHiBvP7qwh5vJGxvwz6AFXCirKF8tNVt23VAnJrn9CErbCceMNZIRKRcwwpg3BLyQ/U7O8z2zHVf4GDd9UQE1zUkt76ukP1IDZTlycRecsxmspOwX/ScPlTayRKYhlZbJUaRjcwpT9AfoiJhOZ1MLgEPHUH7LR04Q/h1x+8YMpc2j6Z0skxtBqpc8aDL7vrVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
https://lore.kernel.org/all/20250811173116.2829786-1-kuniyu@google.com
* [PATCH v2 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
* [PATCH v2 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
* [PATCH v2 net-next 03/12] tcp: Simplify error path in inet_csk_accept().
* [PATCH v2 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
* [PATCH v2 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
* [PATCH v2 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
* [PATCH v2 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
* [PATCH v2 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
* [PATCH v2 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
* [PATCH v2 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
* [PATCH v2 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
* [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from global protocol memory accounting.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6fc666d9-cfec-413c-a98c-75c91ad6c07d

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/a5d5d856-2809-4eee-87ca-2cd1630214ae/config

net/tls/tls_device.c:374:8: error: call to undeclared function 'sk_should_enter_memory_pressure'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

