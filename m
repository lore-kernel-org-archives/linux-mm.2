Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E159BCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 16:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2104C8E0005; Fri, 19 Sep 2025 12:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0468E0002; Fri, 19 Sep 2025 12:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088768E0005; Fri, 19 Sep 2025 12:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E77BF8E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:18:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97DF558334
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:18:32 +0000 (UTC)
X-FDA: 83906507664.15.5E4FAB7
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5D67120006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:18:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N5iU/uMV";
	spf=pass (imf29.hostedemail.com: domain of manish1588@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758298710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU9+sjlQnuFs0nPpSU+fnul/Or/YGJPFrybJE0rZA7Y=;
	b=pM6SGDbeJGCcbnBM3rXBdxJwHt4cG0mCcOe30ZLqDUSB5RsOPCex6CGTWup68YGFcYSSWX
	h073vYDUUN5T8mzPLi8nJDfvlztpRhAtSHcNFR2tg9lHgZ5lY+9lO3/SEaU15xoaldXEDv
	bI4ZTYsTSE0gnQOWZ985K8HDWCJM3RE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="N5iU/uMV";
	spf=pass (imf29.hostedemail.com: domain of manish1588@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758298710; a=rsa-sha256;
	cv=none;
	b=sho0oE2DN6CTw5Wn8yk7SMqGXWHp/vQt2a20uc7eRBELS18n1B/MNXXcPOa/Lyz63gXsVU
	fHrkFz7S+qNoth3Lzo0jzFzF92kU+aNDxN8SXX2jYgh1U9vP/loAFlsdcf3kFwEeqdUww+
	5LZ4EBFIDEw2BlnVOnQYNNU7mZENshQ=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so615505f8f.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758298709; x=1758903509; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AU9+sjlQnuFs0nPpSU+fnul/Or/YGJPFrybJE0rZA7Y=;
        b=N5iU/uMVKIh3PHGJBoiWjezI3ovbWRFxnrk8Zr1ghQudM1qZ0+LQX1qqH1Xsp8xkwO
         LU/XnsrtMK6R7iS9gHSS4kRkp2WA2wlulrRJwUaSao1mQp/+xTWB0QfOk1Eb5qA8+4ad
         AInniYdBfI62T/oEUHQQTicxqXoIefJhD3H2e+aCbB6R4MJKnFEz/ZgpEJfYeZMBQyD5
         mJJojEPFUsXa/JoPdtqHxI/pAcZ+zOnH5oJextIJf9wZfbywsCgjJU9ba8l0p5T+bBYb
         LO1Bb0fHrB/3WxZckDEf9x3f0czbC20L6MFWkJjb3hs15xCbL/32msDsNp0Qi/2NvfHf
         u/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758298709; x=1758903509;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AU9+sjlQnuFs0nPpSU+fnul/Or/YGJPFrybJE0rZA7Y=;
        b=EQjkpUYNeZwhoFA5e9lmfnc4glts91XPYxXts9mtgf6aVQ0HzFwszCC121mFEioUKi
         LPE6MkuXYReKygnFzqdWI7kiYRY0RSX5LrLHutiYwUlbg4v1ldjo49aFCDokTOLhnnY9
         xmmRvGNqlzhTOQmG2k53tQttm7IeLQIJxmeJ4ruA7j8hfZBnKgi1dc9H8BKrE0q4cePf
         UWjtgT1n5Ni12oYPPqWDhW2zP5DPRaJ4KLkAJBiDCWwdYeQqRTng753Xm/Mi5saY4uR5
         AQSakL68p60d7BLzk5v5N+hmu5LcJb93+4M3vmPRELsbWdqiwloI0yO2KRl6toE4H30G
         qTLw==
X-Forwarded-Encrypted: i=1; AJvYcCXqiLDWtsmB8F8NH3mSoSMOBrUy5IZfhvOc2PJ7hXmtj66VBZLOJfVEkOhhF3+VLfoIOwEF5dYfaw==@kvack.org
X-Gm-Message-State: AOJu0Ywhb379LO+mrg6h21/PBpDo/0LZ0nSvIZnqH6LQBl6jgJms+7qG
	rIcjDLFNE0+LQIVQYsU5FvZiGzCu1jbYC6u39Q8iVO8hOW5OEYUUwkiZIoepE2GZiQDs5g9Coui
	q3xK8pSjCpHHAu4QZLsEJgnRWbc1Rg6o=
X-Gm-Gg: ASbGncsC6aga7sDndhAjkT1Y7Yw/rKp+n/ZOybx5HpO0uHmbDa+ghzSXaTVZFOKADJM
	I+9mrduu/qs4GEx00ylzCvzucff+uu1k7IY1HuTgxhl1hC+wBqthV1LXBnllcngaQ9bSibBFdkD
	+JFSjPfFi0zEAWmuWVVUoAsCSofSN+rO9A1GC6ckT2vU1Y2jYp9TRSMpO1E5wwctm7j9WzW8NhE
	gOJBPrQk9iT1NNM7rrEioZYeOQv3UrsljGCYTkXcQ==
X-Google-Smtp-Source: AGHT+IEKwbGqYGVaN2f+8UKTxziV3Lv2awnR5IV0gS/s1CIQ3SFtvsIUW9uJYOV+/W3smsBILrrJ9eu1PbMNqwT225w=
X-Received: by 2002:a05:6000:4014:b0:3e2:4a3e:d3cf with SMTP id
 ffacd0b85a97d-3ee7bad10e6mr3754555f8f.5.1758298708936; Fri, 19 Sep 2025
 09:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250918181403.93812-1-manish1588@gmail.com> <e8121724-a436-47d5-af3a-a16f81cd0649@suse.cz>
In-Reply-To: <e8121724-a436-47d5-af3a-a16f81cd0649@suse.cz>
From: Manish Kumar <manish1588@gmail.com>
Date: Fri, 19 Sep 2025 21:48:17 +0530
X-Gm-Features: AS18NWApCTMAbAQfo55xwI9TbNJwXXqKc2HE_4kqa77Sp5qNNhHJijxjLqrcaHs
Message-ID: <CAAoxDjeUyKs2xN4oBRWnZBWvGLoi4v+nT7ioYVQtB9B2hRj5yw@mail.gmail.com>
Subject: Re: [PATCH] mm/show_mem: update printk/pr_info messages and replace
 legacy printk(KERN_CONT ...) with pr_cont()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000f48e7c063f29d10b"
X-Rspamd-Queue-Id: B5D67120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nxjdjtaynerft6nmwd1gk3enczof6ube
X-HE-Tag: 1758298710-431173
X-HE-Meta: U2FsdGVkX19LzM43z3Alf7g9psePLwr+b0B+CCo7r9+0vO0VnA2x/o/q8TE7dbxeS4vtfZY7MC9AIjWO0ORbEjg8VGoN22pe2RyKufi/fWuV9nrQhBbDsMOBXlMViiTJ2SOBiKVToY6kFw45oCzZ8Dvp5pyEtJNg9W8Pv8Zlfx8SJUZVpJl5r7UIE4gUjtU9w5uIS3bNNLuTaPp3YIKhmHnApq/MXLlE7WufAKbYNodAPNnY7hJ6KdBZdDer15zHfZ9kvo9vAgGc2BpXceY1B9XVmY0G02d4xeGC53G7Hm3FYG2XutFg+ifSum2CEvndMDzzR1XgXqFUcBWELRGBpNqeeG8IprWbBaQNRWQq5p+h49WjBygmiMdbPH8i04d32mbLDnSCjx4mDeNyD6nimOXmYF6flu63hK1WLpxRY/MsnEZa/AEGd5Xp0M0CP+qROuMoNMZt7TRN0ZV48E0758Cjb8NShyhNSmaEplzeTuslPiQIrjmOg7LR97L/52Q5IUV+UuFvAxUioQoNMbk9/TaRIq9iyX6XMgWMipJZHUjrX6qnMkeLzYdXoe3nKLGyW5OvZIz6kxKiQKp5Lg58+sbcDrFSy6bYOV6frEvV9+iwdAd9BWcyMQaOfn3Z7gaFj5ypUtKGfTAnS1mxADGf95yDORTOzokfmBg6cnlFEGI4JerGgbDXjwifE1cqfzF6YOgm9xAD7Jnne1LeVrJj4rB/N7x/C507ObeSvvenoP0dqdBkNIeo7mMdKrVl9pEvqpcqjXPjlce9OQqW7N+vA0aDaxaRrcEnPmyQ+oBNbRQInVZ9KmH113IdOG6jMomJkvTbR2xz8G5+GupqFaEQDimlZ+z1rbkjsl0p7iFqYaT44naEs9FKard8fIs6yvfDnFJjVa2tuOmltxwoG2Th28CBrpRxW+0oEwfGo6h5VTx61oQRKrBs8LBVD20QEpK8rZvahSge4BGBlQSRIIR
 s6YlxakZ
 FVZjrYSLsGtFi2nkEUqPi0x3R9747u31Q2Jai/vCajrKQsnQ+9G1NGLTpmq37WJZLFfeHdF8oL9QDNgnFVmvqHljcabIO9Yh7rb0zV+tO/46CGEBRL/Ii+kuYTAVk5rEy24KjivpnkaUiXRTATefRkYjJe6dj7hOhRMyXdliYFrKb53njmGYaFUqyyf+9ou2u25jm5EsvX7Rv4AUruLm8XP2ugQt+8v5s1N6W4kefDrqK/T65FD6TT1dXMFbQJzMtJeKd8QfTlUexecTDOlaS+S6MjKmjTFXLiEbY8osjwNKO55eoht8wAmlaHAB2w0vuDUN3BymYQmu39F0UtjCHKoxShUY9ipnR9aTi0iqglsjzvUkb/QLRZ+aE23MOZA7M/DSJcTCI2R75xhAwNeGAhVD80Z89lsyXym2DCiSsHRhnui5cgUPfkDvru470zen1VkMnC8EwZe1IDbWBpO6nVhQMsgDcHuY4C4Kgmcwl0HdzjiZI3naDGtKaTuRh0c6S9b4BnXToan4tnMxJGO6Yz2Ee4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f48e7c063f29d10b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the feedback. I understand now that printk=E2=86=92pr_* cleanups=
 are not
accepted as standalone cosmetic patches. I will drop this patch and focus
on patches with real fixes.

Best regards,
Manish Kumar

On Fri, Sep 19, 2025 at 12:16=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:

> Changelog should not be empty even for trivial patches.
>
> On 9/18/25 20:14, Manish Kumar wrote:
> > Signed-off-by: Manish Kumar <manish1588@gmail.com>
>
> This changes 2 of X in the file. Why only these 2? And no, I'm not
> encouraging to resend with a full file changes. We do these modernization=
s
> to new APIs only while changing the code for other reasons, not separatel=
y,
> if there's nothing wrong otherwise with the legacy api. The churn isn't
> worth it.
>
> > ---
> >  mm/show_mem.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/show_mem.c b/mm/show_mem.c
> > index 0cf8bf5d832d..798949d10ce1 100644
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -26,7 +26,7 @@ unsigned long totalcma_pages __read_mostly;
> >  static inline void show_node(struct zone *zone)
> >  {
> >       if (IS_ENABLED(CONFIG_NUMA))
> > -             printk("Node %d ", zone_to_nid(zone));
> > +             pr_info("Node %d ", zone_to_nid(zone));
> >  }
> >
> >  long si_mem_available(void)
> > @@ -156,7 +156,7 @@ static void show_migration_types(unsigned char type=
)
> >       }
> >
> >       *p =3D '\0';
> > -     printk(KERN_CONT "(%s) ", tmp);
> > +     pr_cont("(%s) ", tmp);
> >  }
> >
> >  static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
>
>

--000000000000f48e7c063f29d10b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>Thanks for the feedback. I understand now that =
printk=E2=86=92pr_* cleanups are not<br>accepted as standalone cosmetic pat=
ches. I will drop this patch and focus<br>on patches with real fixes.<br><b=
r>Best regards,<br>Manish Kumar</div><br><div class=3D"gmail_quote gmail_qu=
ote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Sep 19, 2025 a=
t 12:16=E2=80=AFPM Vlastimil Babka &lt;<a href=3D"mailto:vbabka@suse.cz">vb=
abka@suse.cz</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">Changelog should not be empty even for trivial patches.<br>
<br>
On 9/18/25 20:14, Manish Kumar wrote:<br>
&gt; Signed-off-by: Manish Kumar &lt;<a href=3D"mailto:manish1588@gmail.com=
" target=3D"_blank">manish1588@gmail.com</a>&gt;<br>
<br>
This changes 2 of X in the file. Why only these 2? And no, I&#39;m not<br>
encouraging to resend with a full file changes. We do these modernizations<=
br>
to new APIs only while changing the code for other reasons, not separately,=
<br>
if there&#39;s nothing wrong otherwise with the legacy api. The churn isn&#=
39;t<br>
worth it.<br>
<br>
&gt; ---<br>
&gt;=C2=A0 mm/show_mem.c | 4 ++--<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/mm/show_mem.c b/mm/show_mem.c<br>
&gt; index 0cf8bf5d832d..798949d10ce1 100644<br>
&gt; --- a/mm/show_mem.c<br>
&gt; +++ b/mm/show_mem.c<br>
&gt; @@ -26,7 +26,7 @@ unsigned long totalcma_pages __read_mostly;<br>
&gt;=C2=A0 static inline void show_node(struct zone *zone)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ENABLED(CONFIG_NUMA))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(&quot;Node %d =
&quot;, zone_to_nid(zone));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_info(&quot;Node %d=
 &quot;, zone_to_nid(zone));<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 long si_mem_available(void)<br>
&gt; @@ -156,7 +156,7 @@ static void show_migration_types(unsigned char typ=
e)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*p =3D &#39;\0&#39;;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0printk(KERN_CONT &quot;(%s) &quot;, tmp);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0pr_cont(&quot;(%s) &quot;, tmp);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static bool node_has_managed_zones(pg_data_t *pgdat, int max_zon=
e_idx)<br>
<br>
</blockquote></div>

--000000000000f48e7c063f29d10b--

