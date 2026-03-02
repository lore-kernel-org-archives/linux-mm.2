Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C624BD58E78
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 07:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156ED6B0005; Mon,  2 Mar 2026 02:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100C36B0089; Mon,  2 Mar 2026 02:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0035C6B008A; Mon,  2 Mar 2026 02:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E03206B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:43:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FC741609EB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:43:41 +0000 (UTC)
X-FDA: 84500333442.08.F1D9350
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8601E100005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:43:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpRt8tYr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772437419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyPcg/en0FnrdC1hFl4FvwqJB8OzT5i5LhHftecuPsU=;
	b=Lj6uKT44i4PsnmyKTQqk4Ags8pre3kol9012Ew194w0TW4VAOiJTayxDnHGSbmLn8s3rxn
	lMGBJRP3m5Ce8tWG/QrE6QRKt/WGUqvqj8zAodi6zYAeg2tV4eWPRrPZswFc66HXCWu4DB
	8TKyO0votZM4DuYGG0IhA5KNupg45Ro=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpRt8tYr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772437419; a=rsa-sha256;
	cv=pass;
	b=ZdKH3JHLdk3GGaoXJsmIPPL9mZ9N0DG0vg57Va9/oq3xTAthP+dEgc6yaPttOcK0We8hwn
	9C2nWlvip9RxKAyV+jmuOe0XjxHk/UzaJiG4wN9alV33Gem4kQxvYjO9SfOC0Nqgja75st
	/4uk/C2OszyawUwjWWf2KcrbqPl+LWk=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ad46a44easo3372264d50.0
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 23:43:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772437418; cv=none;
        d=google.com; s=arc-20240605;
        b=cxP5XobXnBeksJ2qCLBVWUZO6wNIYD4yz9W9nrdJM3z4KiArBryORXbe28dGj+ubLH
         FtTVeTDx0JdOO8UBFySfyFkTux+Tpo2QGSZcRetAwObb5JjdxmZMz+jBptGoq1+P3/yt
         cC35OmeUC6jKEqZKkSoNS5Du2xWXfgs4S4Y2lBe5RIExco3dWRE05iSHCOJcAAGb44gB
         Mks7YgtF95dRJpnm9juvxTjbHYAiF6FoGwVV3hzaXUx0ee2gEZlVXlCQ6MvH5mfiT7qz
         BW6RFjuPPvjU763dUz6gq+yUtTBCu0+vh4JNUK7CSYIk8hdsLXb+srEZAccToIwR5IRC
         YAzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PyPcg/en0FnrdC1hFl4FvwqJB8OzT5i5LhHftecuPsU=;
        fh=M46pxalaXxC2VgSDrfJ26PaN8tuxya0i2OS1OF7bLd0=;
        b=kDeJRemYs0UIequNCBhw0RBVCA8PNWRx4bisARSSXWHHC7fH0o9x50FzJIAH/W4NGf
         Zb9bEg5RDFsfKmCycSA2K6u+MPrHGyMzUH+yJvLS65cr8VSz3ptFSS+E/zAmbwhdnIel
         0/1Ry+51k8ngzXGLGANITRgz3Q1SWGP1cCkQaaWklQ7WPWuGqUHc7bJ9eIwuBOLfg+Qw
         HxbTTJ6ZiqLL2D+i/E6MScQAkNK1v6Ih8SyUVTizE/GS0vYIvQvrhLinot1cILXT5XTk
         mc1yKqt/bOppKfGcS8GtNY+n/NQ33LEupuNGh9SCTkpmInvnzoqOf0/vPZNNl38Dascu
         ntpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772437418; x=1773042218; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PyPcg/en0FnrdC1hFl4FvwqJB8OzT5i5LhHftecuPsU=;
        b=IpRt8tYr9H0Z8II3CpDuk6NvNeXbUbRz7nLmj11vm5IklF5IMEQ+hkaLNzvKrAVU4x
         1cqOby+Q/f9vBekzcFun5cOq+FX1QUl55n6G9wbx+aN+b+ZGN8kxHDoip+9sC22fUVJp
         Aqb9A6WZrqg3ehO2ESpysB/6hOvKn5rxEgQTr3WGmdPUM2n/Gm4LJTQEyhGNhxbfO866
         VwWCoiBjZO6NKfIihDTIPuddp/1cnW9FA1VeVeN7nkjx6YgouiUGOzc2HUSrMSijcy2r
         bbGrH+x7/GqFem3Yj0fSxCKA3JnuopDVoLh6nu8BXOyX1nT1R/8yOstM4PqJboRrnFHh
         cvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772437418; x=1773042218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PyPcg/en0FnrdC1hFl4FvwqJB8OzT5i5LhHftecuPsU=;
        b=sMTFbLGnF9mDscp+vJdvjw0gqSqgoXhRGV5klnqeYRBHEAcXmo0oX5FWvcdfsDUcXn
         KqvAz2AofkxEtWLsRDcR0I+kWm7t129u8yQuu45q0DD/fqLym+yziDDBa++bX7bantyR
         ywb260yJwyyNNJfkXerjN+aAGAHbw+SNYK0kCwvE8guJ0bDs1hMuhDVVoN2F/Hq5pH/8
         D7qSu3dSC6CSda576r8lBfRv85NUxKfKFMr0iNqj+c0TJTa4hTomKAbQqiijyGDPxioD
         98KwQMv1Gr5LPLXawhKw/3igAhntWqqYG66aGmpyVwKnwzzS9JWndsguB86Trkyz65BH
         dXJw==
X-Forwarded-Encrypted: i=1; AJvYcCUXlWb9RM8aEaDbVQm4aoMJtfAkyF0SGOrXJqppAJU5Vkc/m+FvtlvSPQQO4ZTfr8yIWi78Hqb/5A==@kvack.org
X-Gm-Message-State: AOJu0YyjttZeA0Yik4qgjkK0Dws4nCQORFf+idHP5FW/pJv2hnV49MWd
	yV4ycCXZcmzaO8zCLbeg+PE2GrRw3f2HqfEfUPa3x/5aSFFU3kMw3YwokBhZ0HX4IuwIIALY8f0
	/44vtdrohpPcwzsLk3BEjN7TgqQGl8ZA=
X-Gm-Gg: ATEYQzxmFQSB7esB4AXlCkqMDNUDMxERtPw6OtkqttIev+HMQXmstV0knRFCKBDTIMi
	ucORLRIT905E2/dCuEZZ2RZR/waMsM6sebeyHwoRDPxB0QQnM8aLaWVBoaJlFMiLsHhfHNrNRH+
	nkfGp+x01C8FZ8YcXfNvSOgzS22V2nj5vLShWdeRAoHvW9oxaxFme8SnP0k9XwdBvMXR+S1JSZr
	qhh2h3AEU2CvxdGhRaaKqtvwb1NYXmg6WxPnB1kkvOgOPT45KujOCo3I5+f9/UNve0Ow5By49zc
	NeGRz5NUL9ZJAtPcJNU=
X-Received: by 2002:a05:690e:4286:10b0:64c:a1b9:ff86 with SMTP id
 956f58d0204a3-64cc202785amr7254949d50.14.1772437418451; Sun, 01 Mar 2026
 23:43:38 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com> <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 2 Mar 2026 15:43:02 +0800
X-Gm-Features: AaiRm53sPKWxBhC5UUUtSkE8PvrjHL1Nn5zTnTFpdHpBR_hQ3LkxTEq4ychy_aQ
Message-ID: <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8601E100005
X-Stat-Signature: fxwhhu5oqwqzgg1ankb689a767n7hrcz
X-Rspam-User: 
X-HE-Tag: 1772437419-841379
X-HE-Meta: U2FsdGVkX194dRk9MoME0hQ9yD2lep4e5YeyxK19YZrHFuW8hpLbB0HjXMr+bSbTt05dkqAzAXyoJN1tp5I39svEFGUCnRU6sOWT6SsTziXf1wBNKv3F7QklPqoT8UXJ/enoHAFqoLWZ7IJkLaETtDtkr2dpdU7NBXaWdr/U4jgKHXwDTSpwEV5OuW2SNqGbDK0lcPqRc/dklT7HMSBAoTN3+v+l9QSn4yY1HxFH9rL3g2g2fGQeSIvK59UGLSTNKo4AIb4ykR2vIgrbjhnBGMsjdvxxIdWcd7NCuZ4EkcCUf9WgU6PvgPUCAsKIy7Y1qy41/XkeyGAAAs3NypenHI22AwVB3MkdSojg+wt/JeyDs98KBxEisIc0R7o8RQxbsPc++Cz6AXEGMZKFPN6ecGB088tZTt9qO8kgffbTwPopPbP1XmZYTIa9s+ptoPi016fgxwlxizw7tZemidnfbGlXrQJF6EXjHCKoL2zAuH+uRkcRIM8CH5NO4l2MZsF4USLDbccJeWCRfJQaeoYrBy1lcksPbYyzper1CBhdRG1Qszu9Wm02bKPz9cAlgHuKhg1yFQGTi368H5DtSJIxSxQlbN6DFnzqXqzPcOezjOW+mac02tj3dWpWpa/nSK6TeTGgx6DZx8zx7TI+0lNds8PcyqmH4MonM7LQZlZ9bjtMHkmsdE5M+PzKmGuhm4we/aYwVdyU7lrBdQJN30EM78jxuSC3sRQuMV7kYgAibGl6VGjBQopWSwJY9TE5ACQwNu2c5OtZjY20UoOSwsOkGs2tHgFx1g+1775VcHPkuOVhiw3ZebxPJ6BbpMXvBQPuXshceOu6fStEFY7oYu6lm7qXVe0OCar++ry6jszvp8tBm7GICh6ZdlkcGAF+omIhd64Mj4jNxlUuU4gJyg21jeO3yzMyyn1rnsCsciIimJHyawLLGPVpiIaEt2XZ4VzI9d/5J6tFHqv6Q3AxJz/
 dIQj4xl/
 0frWElcbbM6iKXaCKkvGYrnnFhJkiN4zBIg6ueiEDqNmg7L/pBlURxI+JHljEHmFnhqMuuxkUeksKr/bu6VsDflM6YMPizw0EBcrnRXSLAMwswrQ4HN6NDCYBNVd/NFVCQYyJYlsgWkiZ/VnZ99jEAB/tB9VSIDt8NJrUH+QieHERcnuH1sFtCJ2g9LcGxkFe5D8SIq69D4dWr5au0su7YbxVkDdJWU5c4RIPe6IzcD7+GaYGqFK9YINImNdt3DP8u4sdeIf1BAVicy/34sdsyt+j5Kh2pZIm9R5aHZaM7hjx7b+OBWui2zqTnK1xeKm8nYIzgi3PBBTgS13v+j72bRe+si7p5/VmYrm6PvLIdTy/43LWaddm9fjjWjlbCWGNr+rUL9DSbzT74INyiWVC88qV9b8sFJ4FNQIZ8qLN5rDTbIjx6qJMVppkvrpOusmJscRT9Kfkx+OKtnYgSzDCINlSOWOUwRWWlx0Wb5hhTDfTXnTZya0SYew8L6CnHagWa6mfOSF7N2FiFzw3JziK4AeEhr2p4gh2naN8Z1tlAuOrHGQ901llAD8srma5MHURBDDHkb77Wo97pHsuMg4ASxe/fbA+q+wpc2uR8EBDO0rUwxnmlVr4OY+GMMrFI4iVU0dFnJ+SmNGaTJlTHtTSAkUgsMfuzaVf54R55j8TrxUaA5jwvmdlUujDgVgueYrRNC0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 1:50=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Sun, Mar 1, 2026 at 12:10=E2=80=AFAM Leno Hou <lenohou@gmail.com> =
wrote:
> > > >
> > > > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> > > > condition exists between the state switching and the memory reclaim
> > > > path. This can lead to unexpected cgroup OOM kills, even when plent=
y of
> > > > reclaimable memory is available.
> > > >
> > > > *** Problem Description ***
> > > >
> > > > The issue arises from a "reclaim vacuum" during the transition:
> > > >
> > > > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enable=
d to
> > > >    false before the pages are drained from MGLRU lists back to
> > > >    traditional LRU lists.
> > > > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as =
false
> > > >    and skip the MGLRU path.
> > > > 3. However, these pages might not have reached the traditional LRU =
lists
> > > >    yet, or the changes are not yet visible to all CPUs due to a lac=
k of
> > > >    synchronization.
> > > > 4. get_scan_count() subsequently finds traditional LRU lists empty,
> > > >    concludes there is no reclaimable memory, and triggers an OOM ki=
ll.
> > > >
> > > > A similar race can occur during enablement, where the reclaimer see=
s
> > > > the new state but the MGLRU lists haven't been populated via
> > > > fill_evictable() yet.
> > > >
> > > > *** Solution ***
> > > >
> > > > Introduce a 'draining' state to bridge the gap during transitions:
> > > >
> > > > - Use smp_store_release() and smp_load_acquire() to ensure the visi=
bility
> > > >   of 'enabled' and 'draining' flags across CPUs.
> > > > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an l=
ruvec
> > > >   is in the 'draining' state, the reclaimer will attempt to scan MG=
LRU
> > > >   lists first, and then fall through to traditional LRU lists inste=
ad
> > > >   of returning early. This ensures that folios are visible to at le=
ast
> > > >   one reclaim path at any given time.
> > > >
> > > > *** Reproduction ***
> > > >
> > > > The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> > > > a high-pressure memory cgroup (v1) environment.
> > > >
> > > > Reproduction steps:
> > > > 1. Create a 16GB memcg and populate it with 10GB file cache (5GB ac=
tive)
> > > >    and 8GB active anonymous memory.
> > > > 2. Toggle MGLRU state while performing new memory allocations to fo=
rce
> > > >    direct reclaim.
> > > >
> > > > Reproduction script:
> > > > ---
> > > > #!/bin/bash
> > > > # Fixed reproduction for memcg OOM during MGLRU toggle
> > > > set -euo pipefail
> > > >
> > > > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > > > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> > > >
> > > > # Switch MGLRU dynamically in the background
> > > > switch_mglru() {
> > > >     local orig_val=3D$(cat "$MGLRU_FILE")
> > > >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> > > >         echo n > "$MGLRU_FILE" &
> > > >     else
> > > >         echo y > "$MGLRU_FILE" &
> > > >     fi
> > > > }
> > > >
> > > > # Setup 16G memcg
> > > > mkdir -p "$CGROUP_PATH"
> > > > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_b=
ytes"
> > > > echo $$ > "$CGROUP_PATH/cgroup.procs"
> > > >
> > > > # 1. Build memory pressure (File + Anon)
> > > > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > > > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> > > >
> > > > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > > > sleep 5
> > > >
> > > > # 2. Trigger switch and concurrent allocation
> > > > switch_mglru
> > > > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "=
OOM Triggered"
> > > >
> > > > # Check OOM counter
> > > > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > > > ---
> > > >
> > > > Signed-off-by: Leno Hou <lenohou@gmail.com>
> > > >
> > > > ---
> > > > To: linux-mm@kvack.org
> > > > To: linux-kernel@vger.kernel.org
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > > > Cc: Yuanchu Xie <yuanchu@google.com>
> > > > Cc: Wei Xu <weixugc@google.com>
> > > > Cc: Barry Song <21cnbao@gmail.com>
> > > > Cc: Jialing Wang <wjl.linux@gmail.com>
> > > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > > Cc: Yu Zhao <yuzhao@google.com>
> > > > ---
> > > >  include/linux/mmzone.h |  2 ++
> > > >  mm/vmscan.c            | 14 +++++++++++---
> > > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > index 7fb7331c5725..0648ce91dbc6 100644
> > > > --- a/include/linux/mmzone.h
> > > > +++ b/include/linux/mmzone.h
> > > > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> > > >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR=
_TIERS];
> > > >         /* whether the multi-gen LRU is enabled */
> > > >         bool enabled;
> > > > +       /* whether the multi-gen LRU is draining to LRU */
> > > > +       bool draining;
> > > >         /* the memcg generation this lru_gen_folio belongs to */
> > > >         u8 gen;
> > > >         /* the list segment this lru_gen_folio belongs to */
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 06071995dacc..629a00681163 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabled=
)
> > > >                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> > > >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> > > >
> > > > -                       lruvec->lrugen.enabled =3D enabled;
> > > > +                       smp_store_release(&lruvec->lrugen.enabled, =
enabled);
> > > > +                       smp_store_release(&lruvec->lrugen.draining,=
 true);
> > > >
> > > >                         while (!(enabled ? fill_evictable(lruvec) :=
 drain_evictable(lruvec))) {
> > > >                                 spin_unlock_irq(&lruvec->lru_lock);
> > > > @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabled=
)
> > > >                                 spin_lock_irq(&lruvec->lru_lock);
> > > >                         }
> > > >
> > > > +                       smp_store_release(&lruvec->lrugen.draining,=
 false);
> > > > +
> > > >                         spin_unlock_irq(&lruvec->lru_lock);
> > > >                 }
> > > >
> > > > @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
> > > >         unsigned long nr_to_reclaim =3D sc->nr_to_reclaim;
> > > >         bool proportional_reclaim;
> > > >         struct blk_plug plug;
> > > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.en=
abled);
> > > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.drai=
ning);
> > > >
> > > > -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> > > > +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
> > > >                 lru_gen_shrink_lruvec(lruvec, sc);
> > > > -               return;
> > >
> >
> > Hello Barry,
> >
> > > Is it possible to simply wait for draining to finish instead of perfo=
rming
> > > an lru_gen/lru shrink while lru_gen is being disabled or enabled?
> >
> > This might introduce unexpected latency spikes during the waiting perio=
d.
>
> I assume latency is not a concern for a very rare
> MGLRU on/off case. Do you require the switch to happen
> with zero latency?
> My main concern is the correctness of the code.
>
> Now the proposed patch is:
>
> +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enabled)=
;
> +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draining);
>
> Then choose MGLRU or active/inactive LRU based on
> those values.
>
> However, nothing prevents those values from changing
> after they are read. Even within the shrink path,
> they can still change.

If these values are changed during reclaim, the currently running
reclaimer will continue to operate with the old settings, while any
new reclaimer processes will adopt the new values. This approach
should prevent any immediate issues, but the primary risk of this
lockless method is the potential for a user to rapidly toggle the
MGLRU feature, particularly during an intermediate state.

>
> So I think we need an rwsem or something similar here =E2=80=94
> a read lock for shrink and a write lock for on/off. The
> write lock should happen very rarely.

We can introduce a lock-based mechanism in v2.

>
> >
> > >
> > > Performing a shrink in an intermediate state may still involve a lot =
of
> > > uncertainty, depending on how far the shrink has progressed and how m=
uch
> > > remains in each side=E2=80=99s LRU=EF=BC=9F
> >
> > The workingset might not be reliable in this intermediate state.
> > However, since switching MGLRU should not be a frequent operation in a
> > production environment, I believe the workingset in this intermediate
> > state should not be a concern. The only reason we would enable or
> > disable MGLRU is if we find that certain workloads benefit from
> > it=E2=80=94enabling it when it helps, and disabling it when it causes
> > degradation. There should be no other scenario in which we would need
> > to toggle MGLRU on or off.
> >
> > To identify which workloads can benefit from MGLRU, we must first
> > ensure that switching it on or off is safe=E2=80=94which is precisely w=
hy we
> > are proposing this patch. Once MGLRU is enabled in production, we can
> > continue to improve it. Perhaps in the future, we can even implement a
> > per-workload reclaim mechanism.
>
> To be honest, the on/off toggle is quite odd. If possible,
> I=E2=80=99d prefer not to switch MGLRU or active/inactive
> dynamically. Once it=E2=80=99s set up during system boot, it
> should remain unchanged.

While it is well-suited for Android environments, it is not viable for
Kubernetes production servers, where rebooting is highly disruptive.
This limitation is precisely why we need to introduce dynamic toggles.

>
> If we want a per-workload LRU, this could be a good
> place for eBPF to hook into folio enqueue, dequeue,
> and scanning. There is a project related to this [1][2].
>
> // Policy function hooks
> struct cache_ext_ops {
>        s32 (*policy_init)(struct mem_cgroup *memcg);
>        // Propose folios to evict
>        void (*evict_folios)(struct eviction_ctx *ctx,
>                  struct mem_cgroup *memcg);
>        void (*folio_added)(struct folio *folio);
>        void (*folio_accessed)(struct folio *folio);
>        // Folio was removed: clean up metadata
>        void (*folio_removed)(struct folio *folio);
>        char name[CACHE_EXT_OPS_NAME_LEN];
> };
>
> However, we would need a very strong and convincing
> user case to justify it.

Thanks for the info.
We're actually already running a BPF-based reclaimer in production,
but we don't have immediate plans to upstream or propose it just yet.

>
> [1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
> [2] https://github.com/cache-ext/cache_ext
>
> Thanks
> Barry



--=20
Regards
Yafang

