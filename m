Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A6DCFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1406B002B; Thu, 20 Nov 2025 16:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A87E6B002C; Thu, 20 Nov 2025 16:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6076B002E; Thu, 20 Nov 2025 16:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3356B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:28:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1964C588BD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:28:38 +0000 (UTC)
X-FDA: 84132274716.29.0E78A7F
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EA00C000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:28:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ERFj09Py;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763674116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8U3O6jgZZEpClalOlIGtLCm09UlDJ0npUO0CA7BwqM=;
	b=DK7OgYjuTvdnvjN+NCHc4KAz/Oa6vkqQY3Ufud8t3ezKkqEQUcDHmqdEhsetblhBPyvIJI
	X6nQYMp00rdsErEwiYkNaJ/rdT91r/3Uw68kBhI9AAvYa0Mr8cjMw6YTKNf+DDciGwGdyD
	BKfD7Y506ioyqWRjiBakl+/p4ILf0ME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763674116; a=rsa-sha256;
	cv=none;
	b=qUQho3sxwXGFoAcKUXxg87VDt0on5dJIQQf9dJHQALSlrhHnV9d7VLOhNM3DNb1ApWMNxI
	pljI8HG3IefMCd9wTH6+ySyg06WA3eU8EULR3LZQVFXG3TT84VF+J9l7uAQYsr9Xdf1Iy7
	sR2HoOmaabqwqfg5dcYZdACRQlbBKrM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ERFj09Py;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee0084fd98so10497571cf.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763674115; x=1764278915; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8U3O6jgZZEpClalOlIGtLCm09UlDJ0npUO0CA7BwqM=;
        b=ERFj09PyuDXo7ID3eD6obd7mF2zdLqalsaETzAVRGhE5Lo9hjqTcPYLbOM/gqcZ6Fx
         rhfgbrA4KCH3esadYicZPMG3f9eRG58SX6Fy1hUlEuMhXswYFz3vcpA1eRV1n2uSZjGL
         DV5uE/G9EJ6xaUo5DcAjS16ymuXUOasbQXTbbmZfxcy2MLZpnEpd0E3yvmxyDrKlq96N
         0CEPrHlh82PwuzEGy7Js7t2vOs/xhE5Fuv7P1B9IwaO/8fOHWgct2kULUkNP5jxVPidr
         KrB6vrtootWNbUoRamEQwE5hox5Z1buhIG/MVjrztOsl9WP8m4Uki092PZ/uQM9hHnph
         6B6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763674115; x=1764278915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q8U3O6jgZZEpClalOlIGtLCm09UlDJ0npUO0CA7BwqM=;
        b=DEVxSx62w/NVKum5mBwj5/vIDOMT959grG3DXB/C568S0QIVXe5IjtVatubVihg+2M
         7NfkeRPKCXTjpwsf1t6S8Ct9XI3/n89FHXqMSO0/yRdjF4I/Ex+bDHCsfmnpI6nRU6aP
         CxQdCyx8n5EWj2zyICv1wUpvZwhXOWDyhY99TLKKmaR0x6BOXH6avRAfK1BYm5o7Jcz0
         YyctSSJp+vynhA/w+8drMfcnugs10stnCljOL6yD+rY2dgkg3A7zx0mMI1QMA3R6TMSM
         3mK0dvycmzO+v/sQRixdZPnfbJiDhkCAudDf5L1GEjvMj077UVTdcyGHK8Fjncc6+Omj
         uhBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/JyCsqBtUCg89792bag9k0sv7JaEh8+wWjL+SVE4suHzptgm+bI+Q/ntrnjBWo/zSJufRjVN2bQ==@kvack.org
X-Gm-Message-State: AOJu0YwBnq5Ys+EuBfk/ViTIjIsCZxVN+cTJNVV253yLhxfyIh6rSXyN
	Y1BdGGmFgoX2KMUiYKskP7oPZllB8osuVOnx5Oy//iDMleVpGFV97rdX7BHOADkd+LR1DAiGYnC
	GQK5XX+zmw1tUIJnIUvdNscHPir9wq+8=
X-Gm-Gg: ASbGnctqAwiBjhjd5LW6/wggtSbMVcuBDZQMc4fn3dJBoT7wppsaku6pRcnkTOpVCHn
	NqhD09pyHQJwweKUIcuSQtw//kWhet2DcW5gNc+X0RYD/eUSjAXk6rcrHFrRSlHTxWp+Kj/I46p
	HT1N2M6fyWe2/hEc5Trf4IkLgVRgHKMw9pJXk2r/00N3wQRCoWeFeN9lcXGWFuk44zhep4Glmz1
	+Z1IuNqkwekMlScXB68mDzOGlX+Xv4q9N4zAE4Be07dUduJyRYIAGNWveF6AO55b2Ulzw==
X-Google-Smtp-Source: AGHT+IEa5T+vJspuWQ+toPhdixw0WwlXC4G0HJVZEYNsBGrI4UEp3MsHvbWsFOZ191NkPJIFH9UZtf+mHSYJj1eRNx0=
X-Received: by 2002:a05:622a:4ca:b0:4ee:15af:b938 with SMTP id
 d75a77b69052e-4ee5892e29dmr992241cf.70.1763674115151; Thu, 20 Nov 2025
 13:28:35 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-2-joannelkoong@gmail.com> <7fae20ca-d7b0-4786-8c31-288648db8ad0@kernel.org>
In-Reply-To: <7fae20ca-d7b0-4786-8c31-288648db8ad0@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Nov 2025 13:28:24 -0800
X-Gm-Features: AWmQ_bmnvTHHOQkyw-5ik9LsEU1gIAn8vSNbEvhvGRrj7a058LOg6piKf3ugJVk
Message-ID: <CAJnrk1ZpU3eqh7jN8r-ZPyFsuAjkKgwJ-_Sx0L=710hD0UYwUg@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm: rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to AS_WRITEBACK_MAY_HANG
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev, 
	athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bexqc64eyzy6466ym79xcpotrih4ckj1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EA00C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763674116-651163
X-HE-Meta: U2FsdGVkX19TnV3uDMcbb9TNRLa3s+FhTjB/5wHWFf9WzUkr8CPSd+sOdIkWJWS48vYBEFJcexVafit1IW4JGby3/D17/k1/PMO9hKLLFMyD0V+AkhiZ1lt+N8auq6/rt/U7UNQF30t1n5qzCO4Wz7+BE4wvZEGF8fSjfsjcNzu+maHLKTqeyh8M52HFuKwjBl1SV68ObF3BLfijGVjsd+szD8zP41XCkQqvTdXh5zEwsNlibFLXaJ+AobLba32Ililgk774Q86rpZ73P5vqPFjt1EdPAzT/yxvMTt7mYKZFEn9W+9IfHmrHIFwcMSVcJMEMSb0+dJskNKtoMTW/uJCOvEfddR8UK5hxtVbK/FgpFD6siqtWhLwsSpZ5PIR4dE7WIg65mudgF3vig5njs4Fz71bOKTJhi6oHN0MH3kVhJXG5fK+pGBez4hIXUP/mx4+yC8bjJx7D9oHV4dprUO5mL/3NimIivXqq6YRoUQy7bRzwprip0VQa/UE9bE0c0NuYvKgylrj+Od1wwspckm4hIHX3wWlyEWc1DcLwrvH6AHAVkc9nCuwR3QoHkFuc3HUwdQLE9+ONlkc/jaS1mufERLjpc3SggrSA/16eawybWkwVNicGk0XT+iWlgpG1pwZngMSmT/O7VaG00HOeh17y4TIy11twg/XkDqXntYwNU6seuiHjovcFcL+IxWHIHwSO08Re5rdz/PqoqcA2isqvw7/oSUozYAIEME51WCewNgL3yXBT8mMDhc6+MaIPK9nZw0jYOCwAHPOuyiwQqY3gJ4V2xAro2Z1yMBQ4G3vMPgB+4Iz0NYf1crDuBmDHehyL+f4J6Y/uf9viPd93ZV+ICUFyzGYLPKaG4HOW0QFsdiyxqhRDCc430eI5AxlovrFKbri56PoiXb4yzJGg7vaGZJd+PI0kvbqvmf3sYeiuGxM8SZ2wXR/SSkWtAclx3HAMieVIuEIWVURzS4D
 /QkozL+s
 WNXzVfNStFlPK4DgWgiZhHUzrot4TCc0yOuE/ai3Xz8fu23+zG23g4cA+hjtmq9rXrp64RDpGAumcm9foBKqeEw2uTBFTyqcJ6TNMA7+VDVlxTssGjjyzAr338vKz4LdIAn81JICFJiWvNS42HghmL7R/UZ0KGAgjVrL/v3f9iHRfW88d6369nO/zmN3ywYnfP7DkkC92jsJEeNtVvPWOcbEzDqJWnhwfnmQJwpLCbnasczWtxz6My18lOx+q8lDxHVKB/wJ9XVVGR1jEUxaivETOmEH1h6/OvH/3fUHqEvvgTG7pvSMwyCw1kFWnQNN38lMGiWRZYXkJOWvdFlPPCtH9GZTW1eNTmcbYI9Jd8pkrOql1yPKBwJ2MF6jWaW5x5BAiYrJD+K1rNMVNFzq6/4VjKYag1LXJDZlovVkUb56x/SY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 12:08=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 11/20/25 19:42, Joanne Koong wrote:
> > AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM was added to avoid waiting on
> > writeback during reclaim for inodes belonging to filesystems where
> > a) waiting on writeback in reclaim may lead to a deadlock or
> > b) a writeback request may never complete due to the nature of the
> > filesystem (unrelated to reclaim)
> >
> > Rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to the more generic
> > AS_WRITEBACK_MAY_HANG to reflect mappings where writeback may hang wher=
e
> > the cause could be unrelated to reclaim.
> >
> > This allows us to later use AS_WRITEBACK_MAY_HANG to mitigate other
> > scenarios such as possible hangs when sync waits on writeback.
>
> Hmm, there is a difference whether writeback may hang or whether
> writeback may deadlock.
>
> In particular, isn't it the case that writeback on any filesystem might
> effectively hang forever on I/O errors etc?
>
> Is this going back to the previous flag semantics before we decided on
> AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM? (I'd have to look at the previous
> discussions, but "writeback may take an indefinite amount" in patch #2
> pretty much looks like what I remember there)

Yes, I think if we keep AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, then we
would need another flag to denote the inode should be skipped in
wait_sb_inodes(), which seems unideal. I was considering renaming this
to AS_WRITEBACK_INDETERMINATE but I remember everyone hated that name.

Thanks,
Joanne

>
> --
> Cheers
>
> David

