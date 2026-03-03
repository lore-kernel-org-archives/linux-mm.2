Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55CDEB3649
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301E56B00DC; Mon,  2 Mar 2026 20:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3686B00DD; Mon,  2 Mar 2026 20:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF906B00DE; Mon,  2 Mar 2026 20:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4A06B00DC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8AD88BA5F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:32:32 +0000 (UTC)
X-FDA: 84503026944.01.C314EC2
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2B0A120006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:32:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJLdVbZC;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772501550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoakOWJKYn107a0kMsccm0Mx3Of/ckC1/GrgnYDxGKs=;
	b=LuywSHBdpDCTPdsLnWxe27CqnRTrikeDFCHXdZRubC7Wzsw7mmsQXmNv9TfKAHxwg7NXQ5
	hr3juzZR1PAptPtRuh842Sf4oT6g4ewK4VM1SwJ5NWSE5QjDgSE0oKR5EGebNWMLWWyCew
	LdUrQirJFnXcMoz45i82pSX9a/UIgQc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJLdVbZC;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772501550; a=rsa-sha256;
	cv=pass;
	b=2gGhsgzbLUFi879FyjnMJT2QG8rYL+nROYiLJnqh5pDANGIoe6MArNSXFAeVJ8IH8r/6Ed
	Wh3f+1pAGzcF9EJd9tgQOSXZiW3vaMGz09zYkcsZCoLSl9GidBlgmvhPGyro4sA56lOkzo
	R+ugpRIJMH39Qekd+QffOkCMKQAt3T8=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-389e2950f54so18772021fa.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:32:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772501549; cv=none;
        d=google.com; s=arc-20240605;
        b=LY3O5qxruA/D/Q+DwevqJax74cd7YZzT4jCX7jXnv5clkoJPMGjyaRaR5VhB4Ng6xW
         g4oKPePrlzavO2zmvMpPZJua1FlOehnld4uAM2FqPs9eo4OCYi8BHqLjuOpNTWkNCVYI
         Rw/AxzK287pvggCRBllqPQSyhK1ic+LEsOQxutEnid6TmAtYV3wUJJ3W3/55O5JrsF0H
         1+eaHke2/WyMx9bENGZbtC07fvUIOEKVE2cRA/CDbGephQ+RVsnP65w0HheUn9mvNKF+
         xm8Wdj+FWUlZAWklIey0bQBIiKs97BjooDAGh/0/wvYOYwHA89xDyGlT6sDL2hF7OgPD
         25ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eoakOWJKYn107a0kMsccm0Mx3Of/ckC1/GrgnYDxGKs=;
        fh=EVpZb+tyczsn1A71+LO22pHLFUeq8uvPwxq0YvHUiB4=;
        b=gruxyX3N8Eo5gDk1Z1Uw0/UZNk7FHhoxiQ/g1cmdVYHVjdEoCv8xGXRbfHOFMlE+te
         XQO5hNp9zsZcCjVQM6MotYmFQywsrETyGStMpNSCZFws3hS8gxUL/Agv6xCCAFrIalDA
         Qw5w1W8M7J4eMS8GXI6HSnRLKuONPLkhwD5xavB02XLRd469rbKcF6D3lZbLoEvBXr7P
         WAg2iGcSLN93eMGRm4tYEQNkCCEwC6DPkBbxnX/IJSbnMC8zVNfBDElIg1C2y/l2vniE
         J2kzOqnEQfJbxvKwPhNLBvddSnE4rtsHgEkDCAAxbYselq+7LfvYsdykxb1A7Pjg3Z8Z
         TgWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772501549; x=1773106349; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoakOWJKYn107a0kMsccm0Mx3Of/ckC1/GrgnYDxGKs=;
        b=gJLdVbZCADYakHzTO9bO/TPD99xQSTJGF8xVVCtG7kxSFqKKEMc3qThHspqOYTJWBZ
         CDbGKc1gDrypskC1ph/tkjVKl6xaE1zXfO+8wTFYLDIFULK1nk3sH6Qiwyv58+yglmd6
         e73LQtREa4gWQ/ysHmekLWVYcQOsU/qBfxoCqcKfKPCyzssVXJgHu2HA5alAFX9Y0FBd
         ynJeIX0fP0z7XyNY9SbIpa0et3jxBqdWWD0PkrjTIl2tbO0Yeo2TmkzjFE3aHjyzR7iH
         ec2562iZd1f8mBkddwGw4WGatCGjyxa8pgI3PdTi2Vg89nCcGJojvjVg+nK0pxobf/P4
         ey5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772501549; x=1773106349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eoakOWJKYn107a0kMsccm0Mx3Of/ckC1/GrgnYDxGKs=;
        b=o10SyxMd9DZwxkK9Xla2VfnRbYOyRycZrXx4Yod7b2Z4U0FcVy+H+7gDMl7+YxrXTn
         ZMn641bbVwzUG++VDw72/+stRMKrA0XMGn4YQqOcOC8S5eiiullozTC0WB53DiAa8d9o
         fgsmApLwsshWGJDJyA6uNZmH3qC8qdPvyReJ6Xa5yMEhgEBNY7TSL2udZI9ntrtgcFur
         1rIpXrwpzD90oNPR/zfHZ+BbiMAVOpnpwD2Z4DUOGy5csTWzv84UqL90c0m/4+7hkJdy
         Frvw/yXr0R6Capm6IeNRtcizjNqlVyYcyTVtKUOSKmMo4vSmxkc3CNijm8ZP7jS9YdLE
         IX/A==
X-Forwarded-Encrypted: i=1; AJvYcCWkJwQtpTyYjNI56Jh3g5dIyfGdtZgGcniwGcsAxZIJ8OYdWQz35vEAo4F6JZMcBu89Kgtwadt0tg==@kvack.org
X-Gm-Message-State: AOJu0YxeNpSTOqS6DMI9fIOkfYwIBTLHoB3T17Hbc2j89i/4h/Lj4MhB
	jt5cGyJXnGE2gHnQ4+FrWJ8OwM0sv/3NxUBuAeQ6FLPp67Iyjza/YvLjvsQIWgfjo6wIer7KbIg
	YRyDlbHtG/WItKXJCb5Sh9EsZlVErB+M=
X-Gm-Gg: ATEYQzyM79TGqrHy/i37WDxfKt/0mlbmicB5+lq9KgSgYlhntthaIU2ROEmJKL7O3M1
	KrVWF59gKvlTLLQkfSzg3FpgwgmB0xVGgjXpw8cB0a5Ytm5oLAbnnnJ2YchqKBc++MqgsFXf2HX
	jvcUVAoyBBEzu/jXKrbQ5Zi7m9ZBhTVnauNgpBs6yhl+gcxu4i6r9W5Oj8l1zsHWvRQETd8gYnx
	SL6zVLbXjSKuZcn713uMLX6hj3k7wKrBnTXo17xDKoxQI+/m5JfdpnxMfDrBwofrvJow1kp5PkN
	47DV
X-Received: by 2002:a2e:3a07:0:b0:385:beb9:dbfa with SMTP id
 38308e7fff4ca-38a1c432c1fmr1425651fa.22.1772501548568; Mon, 02 Mar 2026
 17:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260123150108.43443-1-wujianyue000@gmail.com> <20260123150108.43443-2-wujianyue000@gmail.com>
 <aaXoT17JoTv87l40@cmpxchg.org>
In-Reply-To: <aaXoT17JoTv87l40@cmpxchg.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 3 Mar 2026 09:32:16 +0800
X-Gm-Features: AaiRm51MvrbkG34tXAHZrRyVDvmG56_WfTWIft9w2fl79C3OS-RjjlQslYq1xHY
Message-ID: <CAJxJ_jgQLjW_C0h9Lf1BHWbn50miXvJ+rCKurooNzHBDA18ojw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] mm: optimize stat output for 11% sys time reduce
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, inwardvessel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B2B0A120006
X-Stat-Signature: ei6ngnx4t5uh6pshyu7rpfrkutg5fgpa
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772501550-548066
X-HE-Meta: U2FsdGVkX19xHag++psdxFa1Ru4pnr3l3WDLQsVnUjZkBdscJFZiaCHr0OEE9qMA2gjIPUDkcnUYH/hrYy4yWsjVKWQVMQuvCZ89b25LXLuEiGMpkk9HqzBDKQtLPrysGDOzX5yWPK8ancI1XsavGFJd/04JAYxZmaSsAlWkmN/tzQwTvMgu8HvyReQ5fBJqfvLZCoOj7S66XM8CT6HB3TLOBAHQY6uewPRDmbS6ZyeDdWXEmTG4EYaqXZ+6chy96WYxGvQ1ZsAl/vVWPJGp9nZ4cWkR5vnXoBduUMWTZUBiw9UwNujfuTf8QWgyTfkLAvmx+j+IPxNjW55iDkKnUAMHGAMx6RSvYhNYobDdDE2+f2P0Tr+UVLOmf0KPUcHlIGl59Nk3myoLWxInm2IDEbUV8sVR1v0D6FNROrq+Iyjes1tYgsE3LpUci6WV73K2J3usCNHkSVD9duUe2FGloTsOaE3GKinyaKcTwoJlW2aRNt3HuG62PaGEnwSJBFuQjsxAziaY+7VMcB/pVP7BsNkEUJVOiZAoOhOVPsbu9kH1zs8Eao6H4/kCZJ/uqp5K+ZA7yCXTtg8JK/jcyRPYxOV3uVqpRgUldNupHzGaEdeDsyNPy28FVmsc4t9SrjkYwLeTEzGhJuWRSw5T+QmzOlavnKXD95C8hHPjA7gz3BhpOm/7vK1IykP/DU2+uCAvComXHDefIFfdRhFk/iEcvmNSP4e9u4YKkyLLn8hoRhFMIkwIC3SGh9n1G3cSpiurLkNMj2Df12hST6BdytQjjRbVXtTfJLK8D3bx4/KrXYk67wXRuKCPiwNPka6ilRn2UCXtHiykcaSi8Fk8tPAszJFJ9x6nmh8HjgOtlYflaS96bUENK8q7RMRIRmSPUN1waHXSJc/bAL3O3JW0uji9haQlo0txQBEhTK/E3rdvH06tIBkEi7CuH73xXHKaq8k4RiYsibDF8xwHFi+rGQ9
 hCpNCG9k
 P09vqJIaGI9AtYh5S67NREs0YBoVoSL+rkwJ57hWZ++l4wqWgMkF8YkiNtP2m3QigSUaKBeYttqS2SkZQMdN7jThCErz1+4Nd18cjogyPMJ4BGuFFnH/PZlXDUl79V+ZWkC//28TbVmhaoqRA4zX/74oLEyWuSn2DKIAptQEK3MZtBKaSIy93+IlbCwEYpgqw23fiSkRsLPFLcM0zbGyuP5zwyFIUbNi6od7ILMRo9x9nkmD6XU2SNNNN7qC8aeNqrnKwWR4Hp7HCuRJEkBY/EVCSIJQj1w68eUgDfMzAB9VjQRJ7JH2RZH07ak9zBDt8CXT4pufdRqR9BlKhMizTPaJFMfNcPhLp81maIEMtXsyjLtAS5r4PuHGhwAtOK4CnwKeeN6jkK90V9hp+qreIZqWfL7c36e2DSo8E63s3flQh4FLX5d0lFQac8miO8GDLp9fVBShrqgShXKAM3zqOnXAs7tW0Hybbs668UESpLGqsfNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 3:43=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Fri, Jan 23, 2026 at 11:01:08PM +0800, Jianyue Wu wrote:
> > +void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
> > +                           const char *name, char sep, u64 val)
> > +{
> > +     char num_buf[MEMCG_DEC_U64_MAX_LEN + 2];  /* +2 for separator and=
 newline */
> > +     int num_len;
> > +
> > +     /* Embed separator at the beginning */
> > +     num_buf[0] =3D sep;
> > +
> > +     /* Convert number starting at offset 1 */
> > +     num_len =3D num_to_str(num_buf + 1, sizeof(num_buf) - 2, val, 0);
> > +     if (num_len <=3D 0)
> > +             return;
> > +
> > +     /* Embed newline at the end */
> > +     num_buf[num_len + 1] =3D '\n';
> > +
> > +     if (prefix && *prefix && seq_buf_puts(s, prefix))
> > +             return;
> > +     if (seq_buf_puts(s, name))
> > +             return;
> > +     /* Output separator, value, and newline in one call */
> > +     seq_buf_putmem(s, num_buf, num_len + 2);
>
> You seem to be losing the \0 somewhere. I'm getting garbage at the end
> of memory.stat on mm-new:
>
>   [...]
>   thp_swpout_fallback 1212
>   hp_swpout_fallback 1212
>   hp_swpout_fallback 1054
>   907
>   1278
>
> Dropping this patch fixes the issue.

Sorry about that. I wasn't able to reproduce the issue on my side.
On a closer look, the change seems overly complicated and may not be
worth the risk.
Let's drop this patch for now.

