Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B1CED58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816096B0089; Mon,  2 Mar 2026 03:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECC46B008C; Mon,  2 Mar 2026 03:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1456B0093; Mon,  2 Mar 2026 03:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55C2A6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:04:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A94EC2F93
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:04:05 +0000 (UTC)
X-FDA: 84500384850.25.5499815
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 075E340010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:04:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h7hzh9JI;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WprzI80sWoMX/uSOLXGX1gpwyodAZBfRtIAjue07IQ=;
	b=ruNcZLwWnjmQd/taOtOAIYpFFc+IWxj5DEm6vjYTdPIsrSM+vuwcKUIYFda+OHzPEgjVD3
	S2cohbPSv6SdlZgijdcqXGouBZ6sogsFrf8OwzY3sh1/WkeFDoQtBa47gcv+QtzY9pJDoO
	1F236hmzrs4jYQx2rDrD9AbFgv+9NU0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h7hzh9JI;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772438643; a=rsa-sha256;
	cv=pass;
	b=Fi8ulYg7IxSD1Iu12BqE986TezgdseAuo+6RjII4iXCzV/cZYSDyzG/bNWJKTY+0297bKg
	0wmo9yi8DM0s/wEhd0bkBR4rIWp1Ij7heKsyFKa9V/fLQshbLM0+EqpzrKJyT6xFGeQAbh
	EnPbF55o+aNX9VvJXeY7kF/J4qENYKM=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8954a050c19so49999176d6.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:04:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772438642; cv=none;
        d=google.com; s=arc-20240605;
        b=f48dHybZHNDGgS26GHQgys8xk3+HmPBynKl0Vwt++TLJTvgzlh+yR+1VlkbCiYWkAd
         dTz/tsupfU69d8LTuR0VI9eP1eb8dukpWCeeuuvriI+X4nrJh2So5vuxC4oZk3QLfDxg
         IC6W3T4DWsgEJfTTVeiwImjYHWr5HTYfmMfSaqWKzzu2WOh0eILS/vSj5f7Ec8/PF5kG
         o2bOngE+AAZkbLWZVVnAw+DhFJCdZ4LzT+VDTv8jflRZIgZqNDfPPyJku62f0ZZPQK5G
         6YJSPKxMtL13UnSISR4Y+uDzqkBDCIiSHHFt8rlTJth9cxnGBf0drzeXertXCgNlGqlV
         Oong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8WprzI80sWoMX/uSOLXGX1gpwyodAZBfRtIAjue07IQ=;
        fh=O+bvzJcFr/HnuUcnW3uhyeA2KW4rvAW4Bm+V1RZl85k=;
        b=PWbqDxcyzgPlNelHumGvtYQY/viA6VGZVj4NSSNFyk5H2HSz/I1LKBeq3Tbo6zXUb0
         sx6VvDL5HLRQ2NmDaHYvFXEy3Xzspe1NTSHsO9X1U7q0RskKf9RfO4z4eKsir8Pjl1Gj
         3ggwKW/IDy5Fg/8qF7D37PJsH25V3RaRaMtQ+LnQl+BXP5HDVMb7Z0+zex/euhZTFFph
         B8LJH3+1NO0E7HnF1dM2aQdLf8Qp5ymtoIebLTC2iSDIDU6aPrRpCjhxmelJzrzlijJp
         D0AZKXA0LldHdk5zHtTZQTtu9EKPle5uScPkqKuFJfnYwbOaxcMjPLPbGQe7QspinMT0
         8ZQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772438642; x=1773043442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WprzI80sWoMX/uSOLXGX1gpwyodAZBfRtIAjue07IQ=;
        b=h7hzh9JI484U2Uc/D8UyBgbpfzALy9geXmpNUU3LgcmArH9sptDNEMv707NLiTO0+u
         Bt3cDIrTmA6G7Zu7oknz9ckQkk8enFtS0N633w/Y5N6+oZJjiru/d2Yeu/0M5rkR8M3R
         QJewvQD1KCal0g/3s4y9YO7imFlvt4pHIqWnEUBwHMDxqATbA/gMG5uUItIYuNqr5Kyz
         M7IE6Z9EdPLplr8FK6AHDdEAMZzQea3CPLcNodEXQq570CmZaoKvcqUkthuw5BhkkqGL
         Gpm1/qUoI8OVtq5IShtqNs/HTRnWxKGO1zgyC8degP+dDlPajmykoaptZ7PTFxZN1Xg5
         1Q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772438642; x=1773043442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8WprzI80sWoMX/uSOLXGX1gpwyodAZBfRtIAjue07IQ=;
        b=vro49qULExWlBsWR2grQluvoexeuhRoWRnzpYRRiiPqPJ2J0gx9W1aTwMyi+FtGwjG
         Cbw3BF+v4yV4/OR035Je62WVVBWi0PKIqOifJyM8VJ3LXtxt9Kced1k3DQefkxcLX9bi
         BFbTOF+8Oqos9zYVEcPY+vQHXJX+5u4cGa3nGoClwyG93oARbMF8239/U1zpsWXpg1BR
         M4CGYuvlf2sCNKLppj+7ZD3G/2kjWWeMMj3jTYEeK1eJg7LwhJORFPFO89b1sRnR9QMt
         F18rlWS1MpifizMx2oiMGopnifVtwDXnNC/LHfHhAZ4+9dY0JXiMPJVx9o6Hq5+dtln5
         8P4g==
X-Forwarded-Encrypted: i=1; AJvYcCXDSyi/ISG3gLCE3rCzFelsjeQmsm/zC+I0+0Mn1QM4bmeIVcHAxS79RXNJ5Ir+dkjX837CtNJsgQ==@kvack.org
X-Gm-Message-State: AOJu0YzPn9kSNrBzfQaDqrT6imeTGzlNy8bGEgfRKYSZwbpN250HTec7
	OYgZbrRGo1TqT0aBlB6WPkT+C1cDikP/vWpopNoj81zzNHk3uOk50MJVDJZ/4mAhls8zR9hhAKC
	aKA74iq8/LPRqoBVTZVu8hChlulrjXz8=
X-Gm-Gg: ATEYQzyXRpXc6u1h7x0tJABvcWTsFJlFJcPZUTQR5PfF+l/kkCU3h6hxldE54TNYOnk
	OOzyAzl/705+T7D4FuFaAqWJIs6l1B8uLxFqyUq+y5c5LcKOvYHRUFJBPWwY72V3bPVGbZQhFRO
	62OIu0OEP9zcWnKA6JBbBWLLrUsGNIkr3DozP5CfeayBg7c4x2EPedeoxY1c1drrrV89U06H1xR
	1SHxmjuAzAhT/8XzTTmy+JqzvZqwUFZLh3BX8IqU3UY+vzhFkNIti70WEWaQrYsLwx8mFJVK82C
	jau+xYqM3HnwYJ30
X-Received: by 2002:a05:6214:529a:b0:888:3d3b:c9f8 with SMTP id
 6a1803df08f44-899d1e3b43cmr176455176d6.32.1772438641657; Mon, 02 Mar 2026
 00:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com> <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
In-Reply-To: <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 16:03:50 +0800
X-Gm-Features: AaiRm52maN-ELs8WTfFNwtekt3ubLgf_kI-hfzJgJhs5ROgOb837s1fYa0QRjwk
Message-ID: <CAGsJ_4zAY+1feahcVHhJ0NyKHxFZZHJpey1Qd=FAnSnHhh3Yyg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 075E340010
X-Rspamd-Server: rspam07
X-Stat-Signature: c7d9k9sjtrgdmn1dw3j81whye1a4ha38
X-Rspam-User: 
X-HE-Tag: 1772438642-507541
X-HE-Meta: U2FsdGVkX1/PCLGWtM9j9ZcCkV0bNbc7hi+aRv6saRVE0RA0/YFfXNLAxN4vifgk51U7GR1D+xizAy7mrur2gi3yx9U0BJcC3lUAb/Iy0pStJMXRPqpohHBWZx148tKzmfpT8zmaoopawHlWjhVBDk4wAOcLc92DxI8OvactQcNDq5EwkwPKz0P13rPJX7a+9IIHdlUzV+dSThOtiyvNplhovfDWFdUdaHkFZrlrlvR2EWL76bWWecb/CgvyY2sEfOzKzWE+34bbw6xCEBcENcF8eUoiFlYmkuQbhsnCurOKGi9AZ+7yK9aNoQSzazxHlij4oQVqlUIvx5UybCfmsiId6/pgbTSq+RHwRH2k2fqZMAT+T44KQPQCTdya6EWwFrYueM3RRhD30kWyZxWbUoeZA4Mb7T276eH755iSZkPJ6+LhxryGBggQfL4gty5Rl/A3/fjTKSoRa0y/qyFpbVbvYaFk1m/vFR+bk/a+9KGhToj2SoY+HnW7hab4eE66ahaN5lD6GQEwS3+IpQL07sgwwAWqRHSx7NKWhmtuovb9kdK6btG4sjdjc+/v+UiRDk58hho51pOrL+VJ//QIifZBZH4ZyOYDNbRbm/rbda7PhuzOjiIIvXut14RCmw/D/XFxNcesiIazlN5iAmIz6QRBSfSKsSFlb1fP90hMLdHpTSy/I13ZyfvmcFTRb2jAJJOhq6ZDMwg8485VXnXpC5IhJZC0zcth6DQKqNdvNAp94jqy6Sjt/4Wa1f5CV/OBDWw72+zXwuTv9crCRzhBAx27XmqDzau8qTMpdopqUfXBKvdGCLTES3Q5NIclhuHpQ5FrlVvp4A+aVZY3hBvaRhYpeCXM/4hB3Iob0lWqU9DMWmc4fVmbEJ0orUlUiVjMPj2aPlRKzqdc0WlTMgqcnZSWiVmNJQi5PbiDcYYH0kADq1mvn9xc5xbfSpN7kyI347CMcL57gUunrCzhOF0
 K9CKK+nT
 +TJFRzsLLbAPhfSvGa0QuHW3NOnsZbIOiwQzWY/9eqbl0olb5sq/f0u8uNxf6kDMrCbK6qMNzrbOxFPzop2wn59XrBEYGENCkMSbeRZ2M7Ek6AWDMDxh9k88BkLSZ20bkhrYQ9UBa3XkLRp6AInoceItcmdn9j0QRoSgryLIO2ZU1kbX06QAOQwqeAhyxsLt8Z+YszNr4M7oiq1o/E0PUtemvV6pOZJ0dmH8Wwjy2DRUfgwiza8J0dymWHjDA/I3UWdGaH4hheraDzA8hWlka7umfXgYqCl0hxGPmGlzfSFyV89lt0hBSBw66APWSp8TMk6ZiEnPWtrQs/NaQzymAZkw7hmdxnOadFKDTyDYezSKGTQuSD2c1JRlOwBzn4K0h7q9HJoDGLUV7adHFFDCctgFTdoop/FlFk9YZBPcVJlL40p3InNKQvBO8cGSzfexzDOpeCFHWmKpCUuYzbJtErWpnSav+Ln4pSfrCSrA1/hRd8hiQsFDPfYGWOJPs80E4TQ/1jHwXiqhBAqXQPNe0nCH8DcZhu3GhrPYJYyMQ49qAkgAR1/bm09q/VgxzYm9hiotnHG3IRJI+aKYKp7u+Q+KiqRx61+2I5KIIcazQ/Jpzt+aPpM66kr/0wBazZMt0HVjFg/wxxIrh2BaXvqDUysIUPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Mon, Mar 2, 2026 at 1:50=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > On Sun, Mar 1, 2026 at 12:10=E2=80=AFAM Leno Hou <lenohou@gmail.com=
> wrote:
> > > > >
> > > > > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a ra=
ce
> > > > > condition exists between the state switching and the memory recla=
im
> > > > > path. This can lead to unexpected cgroup OOM kills, even when ple=
nty of
> > > > > reclaimable memory is available.
> > > > >
> > > > > *** Problem Description ***
> > > > >
> > > > > The issue arises from a "reclaim vacuum" during the transition:
> > > > >
> > > > > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enab=
led to
> > > > >    false before the pages are drained from MGLRU lists back to
> > > > >    traditional LRU lists.
> > > > > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled a=
s false
> > > > >    and skip the MGLRU path.
> > > > > 3. However, these pages might not have reached the traditional LR=
U lists
> > > > >    yet, or the changes are not yet visible to all CPUs due to a l=
ack of
> > > > >    synchronization.
> > > > > 4. get_scan_count() subsequently finds traditional LRU lists empt=
y,
> > > > >    concludes there is no reclaimable memory, and triggers an OOM =
kill.
> > > > >
> > > > > A similar race can occur during enablement, where the reclaimer s=
ees
> > > > > the new state but the MGLRU lists haven't been populated via
> > > > > fill_evictable() yet.
> > > > >
> > > > > *** Solution ***
> > > > >
> > > > > Introduce a 'draining' state to bridge the gap during transitions=
:
> > > > >
> > > > > - Use smp_store_release() and smp_load_acquire() to ensure the vi=
sibility
> > > > >   of 'enabled' and 'draining' flags across CPUs.
> > > > > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an=
 lruvec
> > > > >   is in the 'draining' state, the reclaimer will attempt to scan =
MGLRU
> > > > >   lists first, and then fall through to traditional LRU lists ins=
tead
> > > > >   of returning early. This ensures that folios are visible to at =
least
> > > > >   one reclaim path at any given time.
> > > > >
> > > > > *** Reproduction ***
> > > > >
> > > > > The issue was consistently reproduced on v6.1.157 and v6.18.3 usi=
ng
> > > > > a high-pressure memory cgroup (v1) environment.
> > > > >
> > > > > Reproduction steps:
> > > > > 1. Create a 16GB memcg and populate it with 10GB file cache (5GB =
active)
> > > > >    and 8GB active anonymous memory.
> > > > > 2. Toggle MGLRU state while performing new memory allocations to =
force
> > > > >    direct reclaim.
> > > > >
> > > > > Reproduction script:
> > > > > ---
> > > > > #!/bin/bash
> > > > > # Fixed reproduction for memcg OOM during MGLRU toggle
> > > > > set -euo pipefail
> > > > >
> > > > > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > > > > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> > > > >
> > > > > # Switch MGLRU dynamically in the background
> > > > > switch_mglru() {
> > > > >     local orig_val=3D$(cat "$MGLRU_FILE")
> > > > >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> > > > >         echo n > "$MGLRU_FILE" &
> > > > >     else
> > > > >         echo y > "$MGLRU_FILE" &
> > > > >     fi
> > > > > }
> > > > >
> > > > > # Setup 16G memcg
> > > > > mkdir -p "$CGROUP_PATH"
> > > > > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in=
_bytes"
> > > > > echo $$ > "$CGROUP_PATH/cgroup.procs"
> > > > >
> > > > > # 1. Build memory pressure (File + Anon)
> > > > > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > > > > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> > > > >
> > > > > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > > > > sleep 5
> > > > >
> > > > > # 2. Trigger switch and concurrent allocation
> > > > > switch_mglru
> > > > > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo=
 "OOM Triggered"
> > > > >
> > > > > # Check OOM counter
> > > > > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > > > > ---
> > > > >
> > > > > Signed-off-by: Leno Hou <lenohou@gmail.com>
> > > > >
> > > > > ---
> > > > > To: linux-mm@kvack.org
> > > > > To: linux-kernel@vger.kernel.org
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > > > > Cc: Yuanchu Xie <yuanchu@google.com>
> > > > > Cc: Wei Xu <weixugc@google.com>
> > > > > Cc: Barry Song <21cnbao@gmail.com>
> > > > > Cc: Jialing Wang <wjl.linux@gmail.com>
> > > > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > > > Cc: Yu Zhao <yuzhao@google.com>
> > > > > ---
> > > > >  include/linux/mmzone.h |  2 ++
> > > > >  mm/vmscan.c            | 14 +++++++++++---
> > > > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > index 7fb7331c5725..0648ce91dbc6 100644
> > > > > --- a/include/linux/mmzone.h
> > > > > +++ b/include/linux/mmzone.h
> > > > > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> > > > >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_=
NR_TIERS];
> > > > >         /* whether the multi-gen LRU is enabled */
> > > > >         bool enabled;
> > > > > +       /* whether the multi-gen LRU is draining to LRU */
> > > > > +       bool draining;
> > > > >         /* the memcg generation this lru_gen_folio belongs to */
> > > > >         u8 gen;
> > > > >         /* the list segment this lru_gen_folio belongs to */
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 06071995dacc..629a00681163 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabl=
ed)
> > > > >                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> > > > >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> > > > >
> > > > > -                       lruvec->lrugen.enabled =3D enabled;
> > > > > +                       smp_store_release(&lruvec->lrugen.enabled=
, enabled);
> > > > > +                       smp_store_release(&lruvec->lrugen.drainin=
g, true);
> > > > >
> > > > >                         while (!(enabled ? fill_evictable(lruvec)=
 : drain_evictable(lruvec))) {
> > > > >                                 spin_unlock_irq(&lruvec->lru_lock=
);
> > > > > @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabl=
ed)
> > > > >                                 spin_lock_irq(&lruvec->lru_lock);
> > > > >                         }
> > > > >
> > > > > +                       smp_store_release(&lruvec->lrugen.drainin=
g, false);
> > > > > +
> > > > >                         spin_unlock_irq(&lruvec->lru_lock);
> > > > >                 }
> > > > >
> > > > > @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *=
lruvec, struct scan_control *sc)
> > > > >         unsigned long nr_to_reclaim =3D sc->nr_to_reclaim;
> > > > >         bool proportional_reclaim;
> > > > >         struct blk_plug plug;
> > > > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.=
enabled);
> > > > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.dr=
aining);
> > > > >
> > > > > -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> > > > > +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)) =
{
> > > > >                 lru_gen_shrink_lruvec(lruvec, sc);
> > > > > -               return;
> > > >
> > >
> > > Hello Barry,
> > >
> > > > Is it possible to simply wait for draining to finish instead of per=
forming
> > > > an lru_gen/lru shrink while lru_gen is being disabled or enabled?
> > >
> > > This might introduce unexpected latency spikes during the waiting per=
iod.
> >
> > I assume latency is not a concern for a very rare
> > MGLRU on/off case. Do you require the switch to happen
> > with zero latency?
> > My main concern is the correctness of the code.
> >
> > Now the proposed patch is:
> >
> > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enable=
d);
> > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draining=
);
> >
> > Then choose MGLRU or active/inactive LRU based on
> > those values.
> >
> > However, nothing prevents those values from changing
> > after they are read. Even within the shrink path,
> > they can still change.
>
> If these values are changed during reclaim, the currently running
> reclaimer will continue to operate with the old settings, while any
> new reclaimer processes will adopt the new values. This approach
> should prevent any immediate issues, but the primary risk of this
> lockless method is the potential for a user to rapidly toggle the
> MGLRU feature, particularly during an intermediate state.
>
> >
> > So I think we need an rwsem or something similar here =E2=80=94
> > a read lock for shrink and a write lock for on/off. The
> > write lock should happen very rarely.
>
> We can introduce a lock-based mechanism in v2.

Honestly, the on/off toggle is quite fragile. For instance,

folio_check_references() is doing:

        if (lru_gen_enabled()) {
                if (!referenced_ptes)
                        return FOLIOREF_RECLAIM;

                return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE :
FOLIOREF_KEEP;
        }

However, `lru_gen_enabled()` does not indicate the actual LRU
where the folio resides.

`lru_gen_enabled()` is called in many places, but in this case it does
not accurately reflect where folios are placed if a dynamic toggle is
active. During the switching, many unexpected behaviors may occur.

>
> >
> > >
> > > >
> > > > Performing a shrink in an intermediate state may still involve a lo=
t of
> > > > uncertainty, depending on how far the shrink has progressed and how=
 much
> > > > remains in each side=E2=80=99s LRU=EF=BC=9F
> > >
> > > The workingset might not be reliable in this intermediate state.
> > > However, since switching MGLRU should not be a frequent operation in =
a
> > > production environment, I believe the workingset in this intermediate
> > > state should not be a concern. The only reason we would enable or
> > > disable MGLRU is if we find that certain workloads benefit from
> > > it=E2=80=94enabling it when it helps, and disabling it when it causes
> > > degradation. There should be no other scenario in which we would need
> > > to toggle MGLRU on or off.
> > >
> > > To identify which workloads can benefit from MGLRU, we must first
> > > ensure that switching it on or off is safe=E2=80=94which is precisely=
 why we
> > > are proposing this patch. Once MGLRU is enabled in production, we can
> > > continue to improve it. Perhaps in the future, we can even implement =
a
> > > per-workload reclaim mechanism.
> >
> > To be honest, the on/off toggle is quite odd. If possible,
> > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > dynamically. Once it=E2=80=99s set up during system boot, it
> > should remain unchanged.
>
> While it is well-suited for Android environments, it is not viable for
> Kubernetes production servers, where rebooting is highly disruptive.
> This limitation is precisely why we need to introduce dynamic toggles.

Perhaps we really need to unify MGLRU with the active/inactive lists,
combining the benefits of both approaches. The dynamic toggle, as it
stands, is quite fragile.
A topic was suggested by Kairui here [1].

>
> >
> > If we want a per-workload LRU, this could be a good
> > place for eBPF to hook into folio enqueue, dequeue,
> > and scanning. There is a project related to this [1][2].
> >
> > // Policy function hooks
> > struct cache_ext_ops {
> >        s32 (*policy_init)(struct mem_cgroup *memcg);
> >        // Propose folios to evict
> >        void (*evict_folios)(struct eviction_ctx *ctx,
> >                  struct mem_cgroup *memcg);
> >        void (*folio_added)(struct folio *folio);
> >        void (*folio_accessed)(struct folio *folio);
> >        // Folio was removed: clean up metadata
> >        void (*folio_removed)(struct folio *folio);
> >        char name[CACHE_EXT_OPS_NAME_LEN];
> > };
> >
> > However, we would need a very strong and convincing
> > user case to justify it.
>
> Thanks for the info.
> We're actually already running a BPF-based reclaimer in production,
> but we don't have immediate plans to upstream or propose it just yet.

I know you are always far ahead of everyone else. I=E2=80=99m looking forwa=
rd
to seeing your code and use cases when you are ready.

[1] https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75su38w=
=3DHD782T5E_cxyeCeH_g@mail.gmail.com/

Thanks
Barry

