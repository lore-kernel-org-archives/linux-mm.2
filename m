Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D3FC9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED72D6B0088; Sat, 26 Sep 2026 03:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88706B008A; Sat, 26 Sep 2026 03:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D771E6B008C; Sat, 26 Sep 2026 03:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4D2B6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:06:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F9AC407C9
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:06:31 +0000 (UTC)
X-FDA: 85255030182.03.E0A034C
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id 250B440002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:06:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YyIDIzQC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790406389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGKzzvyJ/o3BKDYXGpul4dMsPx6vROBnNG4DQ1Eg7QE=;
	b=EedwzDLJg/Zf2iLTaF3onGTn8JSk9AtD6E1pfvnpOs/E6jIgE1EIeSXjADGgQJQ4uMFVCW
	WqSz+0c5Wjpl4vdgANARSVEyB7UyO7QdQGCGelaQztSjF6vG4u/MXkFve3qAMOB/Zg/Xf+
	aR0/+EdTmtKhFs360QwjfELNgS8XJac=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YyIDIzQC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790406389;
	b=Q9QwzACH41BmhxTrLQHbavjxnuLrwIi3q40cWKgfatultiNTWTgHvPVtnoJ3Dy+54oCgI2
	GYPjBZMsJGSgRnpEQVjKDMVdA6SidBd9LRwFkCh45YiW6mibtE8CH5dWCWR/G5tVDbktZl
	Kg3UgLIyGCmJ4Ntrb+AuYp9KiKcHrAM=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb796so226520666b.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790406388; cv=none;
        d=google.com; s=arc-20260327;
        b=MWElW1jdYiqHSzOtJjGOLqyPGpKSfqKHhWnLDjWUDx75wNvQtuUVkZyNuOCEZAuEAa
         owEo9lZl0bd6ZKl9xH+DfpV6u2H6DArl8Og5bNy7KVjsDp8dN73p9gXcpRA2ce6XIa6O
         S2Q72V9M+oiGeUk8qEr1RmuZ+3kr1jAl3AK/frq1nMCpmbFsR+mUNrNyvc08NhRBbyKB
         rgxy1KwkqvTwR8k+ZhJtnE7ux8comV5cWqza8AD6BBKyVXGAwNLrd99HT2DBTl+j4uF2
         QSrnZElXDmfyF6NC45/LWINnkBF1mMSNIpM/VPGWwFtdBdkZcfBFURc4HLg8dYyqdspf
         WwCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dGKzzvyJ/o3BKDYXGpul4dMsPx6vROBnNG4DQ1Eg7QE=;
        fh=XouV0UHpynTB6udBGKcNJuTgl6xf+ifCAGTDx4iAVFs=;
        b=B2NUZ0JoTkDE16dEMKA/jjBj/1JC8RCG9LABXDc+t9634MrLIe1CB/7XTOe0NFZtee
         JjpERDaYji7/XlIrR3Ni+1Sl16vxEcSSDLHcs4eBS62PRtLTY5rCbUkEKInX1CoJttIa
         JIqupUvwhEPFZk+Az/zTcvDGn8SYCU1yN6TUWP2cHd1SexBQkjLVXJOaB8xWyM+X4JuG
         +KsgDUtNGgQyTkFC+6oUGm9tsxX7rplxlxnBC6ynbKuvbqxvYQAdFbVoZup7hi3Isj1j
         6/jRJ6ZLlhCpdaGQp1HOmb8BLqOEjLuSoGyGq7XVcQtKSey0OEuOSTBHx/Bw1Nt5zb4i
         quIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790406388; x=1791011188; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dGKzzvyJ/o3BKDYXGpul4dMsPx6vROBnNG4DQ1Eg7QE=;
        b=YyIDIzQCu/ZwMECSj2X74ysNtbHiAJDwUFii/etWf2H1lklDZvVaL4Exher5Q+gZDm
         q8LTgVEFle2EYj9Mk3QFJCiTNLDS9FU6PdX/vdaL/I0sTCg3TfTmOtrqxAOjY/+4oOXa
         +vGigMc4NUYVmx8V6A8Dsb8ObrJwq7hIfY1TUyWoPMXXpq2yww9SiRZN2PLBNdzeyqRc
         A0o/mNH8/0KI1khgPm4zQyOj0pTZjciE6MChZxVJEKZJjay97KIgBje2+O3SlcOFM5fO
         WlcTbxLaaa7VICIfhi/x/2Y1L2Y8VBkk9piYCxzB8mRJ1jOva2IZqi7N55y2poJFe86Y
         7qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790406388; x=1791011188;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dGKzzvyJ/o3BKDYXGpul4dMsPx6vROBnNG4DQ1Eg7QE=;
        b=LC9ykachpq7jjMBpcVsOLQuud+Amibrh8uQbp0jeB3TJ8G8AGyEgEoIOgcpaeTtVaU
         3nrctvDXtoPQD+jb5JfOVccpKV/JsGZFx5/4qsL3QG2SGXhxiTHLuccYFxVKRemj1Caj
         iY4uV+/7kFOFeBBRyQWI/qgGhbVTElOED5nAGOb3ICrL9PxV9Fc6jU1x9leVDr3wO3iG
         HMP6ci5nyzSq7haCeBG/oTyQ4xOb9w1lwDeQjZ7V2FhoMP4TybxXt3UG4SJelIWA/Eqp
         3Fbunbsp2KmgB0MrBKcVkESo3cYY0I9mGj2EZIbk3/yBnsLeDgLwStPFXPnmaijKvxkb
         NmXQ==
X-Forwarded-Encrypted: i=1; AKwUvBzo/xWEltmSEWR+3s+D/Pjt3ZSwz5yMxmR391Bd+ThYtzzJtc2X/1gDuz50/gvCIWEM6a1TaAH2/A==@kvack.org
X-Gm-Message-State: AFuF++nmvitgwg2HMkLHrERG009NeR4fCHmfTnDpfAyPxmuFGtB+DlAu
	3FHsm/0PhRbLlQd6RfDwsJRjWfuBEgQ7285OwDEU3oGWo71zxyVXbaunU5lLHFjh3sT8imGremc
	8kTSWVJnE+L6WG9rgCYzlCSBWDFZWros=
X-Gm-Gg: AYBFou0+WEX6EYIkV80t5a7CnfPivcHK6aLeih/Y3Nh9m9DH3LhnAHe+GSlPXyAyDCD
	D8MeRjpAzMziMIHOxFi3d9rBqkbQxhIp3DvTxj1h/aWyIIkXkKsDyozNbcj2CAN0tLpBlqeWDr9
	1JDSbqxeW/cuSZwyywMKJDvfOa0pC7S2mh5YH8nYzBwl1ENAf74F7u4WjIZ6yGtYXTZySiV5pab
	zgYdyxFLSYRYBF8luZ1KmTL6t4qbowT0GAL4FoQ3th8oROBEMS5+ZdWLZn3Zc+lbjb2YwNy8EHN
	nffEPXgegdAQV8E5F/dwhC8/5QzK5vWapBY3eXVMeJOojHwdYCjLi5nE9M6I+Kv7+F5vPOfQK+X
	WXZjQ6bfmIxY=
X-Received: by 2002:a17:907:3ea7:b0:c25:5a7:87f with SMTP id
 a640c23a62f3a-c2ac2163c4cmr712043666b.0.1790406387384; Sat, 26 Sep 2026
 00:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <apcVhWzEwkwHYjB1@KASONG-MC4> <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com> <SJ1PR11MB610584E71CD980C9F85952F38C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB610584E71CD980C9F85952F38C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 26 Sep 2026 15:05:50 +0800
X-Gm-Features: AclHuK_Vi673nZpGT-Km1bFZg8K_EDbD_Awuc0fRGGx1yNSeHTuqCzUXAghq6IY
Message-ID: <CAMgjq7CMd7v=kYwWGSyt2LmMep6tQcFFsdyBpwc_X+s_Km=rZQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Lance Yang <lance.yang@linux.dev>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4j9gs33midd4944oc7wmn1mahbj51pwo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 250B440002
X-HE-Tag: 1790406389-269926
X-HE-Meta: U2FsdGVkX19raXeVtG01FVQbN/UuojE01H+OY9swYdxvrYtmwoxVzcrD60uvFtvIcFBa5DVhtWiZM3qHlgImBG8rjSqsh3rSIRG2s44SQMAi1E53DwlkqX7+cefv2A8UfKRFYbQ0MIxm5taym5CrXp7MBA0Zd1mpya6UIiOExA+PN5HEdu102guE2bA+HZFxqf6vGXjOfcsJxivJkICqttG81YohB3Nk7gDuNW0VgKQqYibF1Mx0eLc++MzEaSRX0uj1Sua1BRG0DTJmgcSEWfdlMZkNuRt+1N3R4TM8H7PtVbs4hIrUIFY74FShf8v45Y8C+89BKgLjE3zkvlZjpgA6iqlUDwNqigJSWxzCN8mFHBv5i8yngjbo7Io9/vDORj4hXrZ42z0+aD1bWEY9h0RBroFY2d7w+mCHKkk1as7swCfkzh3QKhHeRe0sd3/qpFMPrW42Cr+3m03/DFthQ3ICfoo9ofEG9Jex0WzpAzB/4Ta5ZmeAOACNa7cDNL1HkXQ8wTQFNW/je/lB7pn+kTNytW7hakneP1USmm2LPRwekgJVLn7StF7DZyDGCsXk+vjbsXQi0MRUwdQL1xl6cWgtKeIt3Z+Zw7LWQle9MdFhyrahQ2jVxWaEUVYxwNHjRC7rgKNEXwmoZ3W/qNjCY4/0KHA3ewKSeti1fRkfR11F17K8pOkrRCY4+K6JUqwyDIx/Fj+h5hDvo5UZkR672zgAzKc+OsxhRmidPmMHNGziWyEUGgAdbztD4JsHzgJbKkUwwcbGdpTogu+u76q1IOsN5T9xlijzKdDDLSblTWUXhssh8JoNzUsvIZxZlKR6L2GUza6CzAwW5/wQg+UuNZa2u3cr6uB2tZPb09+KTeVgj4Ah2cxGlz8m23QpoVzQGSYVvC4xAJd20ChUbd1nnvy88O7qbCOL7JsY6Dl0aM31wniPYrQZULnGLNeq8jG96cbBmZ755+qLS4uXIcN
 Nd+2gmz3
 BeF9CN2nnQ7/1Khz5HC8PbYu1AucIn3sWuNS+AbKqKBSFxr/OjxyZrdPzz3rupwmpPf9UuiZ2GqE+h8QbB9Gq+OPn14l4ZLxegh5+aTfvXFi5lCnqXemR0BWQx9eXXJl8tlhk9hLUL8WRm70Mlnc8tMmfwEHjXVImAjoHKLIUpa5V6l5n0umg2qSDc5SqgzRws3OggUeWz44nyNsVmOt24+reYG7nCWlSK92IFqYsJewz/myJmtMqRUr6LDGVb7DPTPcKSO2PAkFmjlfs50EQLWRCxmfwKh1/T3JaEjQ2NPrUYD2PchwVlfXXPTsY3oEkOQcB1Hz5N0fDUjfAfOhnY7BT7yxqckUGJV+tdH4d9SWPoLG/aijrzyn3nQzmLQVPcHvBATGNeP9WUiWGwf3U+z/IfkX+BD4l/SZlgGiz3ZV0ih2ZskgeU1hojxQgEOut512Ukbqos8rcSP8uYdyj56jOv46WVLPUBBX9y036Qyu7uPXje/zgqPO6sRy1oL1I9KuXLRvg2FxYyWZDHu/ufCo8h1LWNDKhPbTBJJ+P+uXR3TJjDK1eDIKsR+pZb1T1tV40uMS1mPy9g9VEEJds71Two+z5BqnPj6YpvvNDq8JX5byV49OJ3IZ49n6VFty/frTe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ababneh, Ehab <ehab.ababneh@intel.com> =E4=BA=8E 2026=E5=B9=B49=E6=9C=8825=
=E6=97=A5=E5=91=A8=E4=BA=94 01:54=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Barry,
>
> > -----Original Message-----
> > From: Barry Song <baohua@kernel.org>
> > Sent: Wednesday, September 23, 2026 9:08 PM
> > To: Ababneh, Ehab <ehab.ababneh@intel.com>
> > Cc: ryncsn@gmail.com; akpm@linux-foundation.org;
> > axelrasmussen@google.com; kasong@tencent.com; lance.yang@linux.dev;
> > linux-kernel@vger.kernel.org; linux-mm@kvack.org; qi.zheng@linux.dev;
> > shakeel.butt@linux.dev; weixugc@google.com; yuanchu@google.com;
> > yuzhao@google.com
> > Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault
> > folios under refault pressure
> >
> > On Thu, Sep 24, 2026 at 11:43=E2=80=AFAM Ababneh, Ehab
> > <ehab.ababneh@intel.com> wrote:
> > >
> > > Hi Kairui, Barry,
> > >
> > > Apologies for the delay in getting back to you with these results =E2=
=80=94 my
> > > test environment got corrupted and I had to spend some time recoverin=
g
> > > it before I could re-run the benchmark.
> >
> > No worries, Ehab. And thanks very much for your testing!
> >
> > [...]
> >
> > > > > > I agree that reverting the commit that caused the regression is
> > > > > > not the optimal path. I expect there are many workloads and
> > > > > > scenarios that benefit from the behavior introduced by that
> > > > > > commit, so reverting it could unnecessarily regress those workl=
oads.
> > > > > >
> > > > > > I will run the Cassandra benchmark with Kairui's MGLRU-FG
> > > > > > patches to see whether they address the issue I am seeing. I
> > > > > > will send the results when they are ready.
> > > > > >
> > >
> > > Thanks for the pointer =E2=80=94 I gave your MGLRU-FG fix a try again=
st the
> > > same Cassandra read benchmark I used for my patch (4 nodes, 720s, 100
> > readers).
> > >
> > > Results with MGLRU-FG:
> > >   Op rate:                  55.0k - 56.5k op/s
>
> >
> > I noticed this is even higher than your dynamic readahead fix: "through=
put
> > ~51.9k-52.7k op/s"
> >
> > Is this a run-to-run variation, or is the improvement stable across run=
s?
> >
>
> Yes, I can't explain the slight gain in throughput but loss in latency co=
mpared
> to my fix. I'll probably study this in more detail when I can dedicate so=
me
> time to it.

Hi Ehab,

That's very interesting, I think it means we are getting a bit better
at identifying the working set. But maybe a slightly high cost of
aging? And P99 is usually very sensitive to noises, one long tailing
aging event could make it look a lot worse.

> Typically, I get a unique result immediately after a reboot, but subseque=
nt
> runs are very consistent. The variation is usually around 0.1 ms gain/los=
s in
> latency and approximately 100-200 requests per second in throughput. I
> discard the results from the first run.

Any way I can reproduce this? E.g. what is the test bench, database
size, benchmark, machine spec, etc?

> > >   Latency 99th percentile:  6.8 - 6.9 ms
> > >
> > > For reference, here's where the other variants landed on the same set=
up:
> > >
> > >   Regression (6cbdd9726fb5, "mm/mglru: use folio_mark_accessed to
> > >   replace folio_set_active"):
> > >       p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
> > >
> > >   Revert of 6cbdd9726fb5:
> > >       p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
> > >
> > >   My dynamic readahead-credit fix:
> > >       p99 ~5.8 ms, throughput ~51.9k-52.7k op/s
> > >
> > > So MGLRU-FG recovers most of the latency regression, but the revert
> > > and my fix still recover more of it: p99 with MGLRU-FG is noticeably
> > > higher than with the revert and my fix (6.8-6.9 ms vs ~5.5-5.8 ms),
> > > though it's still a big improvement over the regression's 9.2-9.5 ms

Did you test the V2 or V1 of MGLRU-FG? V2 includes Barry's aging
optimization; I'm not sure if this latency is caused by aging or maybe
some other change.

And is there any swap device you used, or is the test using the same
base commit? MM also changes significantly between different
baselines.

