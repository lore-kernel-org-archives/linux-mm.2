Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A26E7FDF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 22:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96316B0005; Mon,  2 Feb 2026 17:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43DA6B0088; Mon,  2 Feb 2026 17:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FDA6B0089; Mon,  2 Feb 2026 17:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B281E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:07:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CE1313A633
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:07:38 +0000 (UTC)
X-FDA: 84400904196.17.A0F0666
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C783140002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:07:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hog5BhF0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770070056; a=rsa-sha256;
	cv=pass;
	b=SmiMBqEg54MUUraXaxavUEU1B1fgHF8YMofh+d7ndIIY8uH1XTLusr4La9ptgpYreqG3Ch
	fnuuBlRNhalkeEOz51W+8yx+QcTkzNHC728ue8DY2jPEQ6WDUMoXPasJj3MhcLh37cdZMr
	FhkU+Z+HwMvXurfAg6QMojsWVdHTs2s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hog5BhF0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770070056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7rWSHX2ukGV/v2YgHeyDbFBzVMMATarwYlIyO+26bc=;
	b=RQO/TmPsZZCnnkoJaV7rTkBU5Dk/xGl5htnLEmi5Jnsa06T2xidNxWXZUvaFYQN8o8/8XX
	xIkTB1aT9a2I+C7hQKP3nSf1gt31JHMXSCDUGvvRUxjpp1B7+CnJ1KkvjE2WMpMuGxL32S
	8f8hw++5v5GMuB1XmuttafmTGCtU6Is=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fb2314eb0so4069810f8f.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 14:07:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770070055; cv=none;
        d=google.com; s=arc-20240605;
        b=Dt9Pf2lraTSuG2Q8SIMHmpeRinjUp24pvNmJ/UGLjq9xBwwkzbHdfBBi2p9nV/ADyz
         He/AtTVXfL6+cEoLCTaM5ishsInLpE9u6gW8KN+jGoJQhuparLPtOb7BKxUfCnE/Kbjs
         WU/9BQ5uT2m3O7Pu3BE6e6g/GDLopW8JRyWgqMqvuAJa4ge8tr2g6hyq0rVIqhDszYGq
         xDi4tz7Z2AbItfFpl63tFo+LVlf1ZHorm6fDOV+5ZGqWST29gbAm/A9dUmPha3UkbmY1
         Kf44d5Mcc6cvnjfvZ64XsPaxpoN7ENqxvEUWI8XCGj8krstq/gedGbLkJ79wy7xEwi2H
         0N2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k7rWSHX2ukGV/v2YgHeyDbFBzVMMATarwYlIyO+26bc=;
        fh=0eEf8Mm2gdm5o+bQ5CVvNQihzceQuCXF82UTma3cUVw=;
        b=VB5nE6Bf04+a3hHrdN3PaW+Ae0YeyPKqmEbfLN38egbbY6eX2lnaBQpArZjEGSkexz
         W7fmdpAebL4y7m/K984MGSNz5GxlvTNConBe6ZbAZGGrArrDqoEk1eY7OpjFoqH4TMiS
         ikU//qgEZauUvaqqqZ4CvfA7TbHmINpytNpD6ARrzDYLuIXq/oUfuOe+jA1XZB1kTANa
         rmFkdyzvWviy7d8wxVxy3hmDaoq2PgqFgA7YjvBSnyZoQ44fEXcQ7C+tYqMF8G39T84l
         Ke9uCrPfx5qV1vC6q4LyzaG9OnzDf85RHYnmnt6i1/qSeWTo+rQVYqOx3eaHjAiEiowj
         owig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770070055; x=1770674855; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7rWSHX2ukGV/v2YgHeyDbFBzVMMATarwYlIyO+26bc=;
        b=Hog5BhF0dDrcyDbNnHGxfZKV4kcHB86UnuGnbG3tuG5QyRqtGNxyC6jfJ1iIH2MFLW
         7JNcP0sgVkMUBkCojD34VBus2eSXGKzh783fA0pmhY7bmmZ38pVOmictR2IQcJxInj0b
         sbcl3SIOtCZwQzzH43jPEslYh4Iw4Ke42EbZxr/AIuFVwG9WMgc9ys4IMI5x7gJOXeB7
         GM6dZl85iECPnZGCgsqvJWGPQ8SuCkZao4ssz6yZpbsj3CJM2T+J5OCfYAZPHK4HPvK4
         nXngUkVAAMiU8bBo676IY2E0q8r+c0Q0ejgvbPheA7mrjdFfS0tbu+7NxwQBA83zTV5+
         zAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770070055; x=1770674855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k7rWSHX2ukGV/v2YgHeyDbFBzVMMATarwYlIyO+26bc=;
        b=MzR9Agai2k2R7BMnYpOjH0kyGJtu6uyajOxCr+dS+qN1/oPnAqDalLO+B/OiqztoM7
         s9FJnumMcC4oO4TBBe/vzfVh9rD1/EGkjnDSztm3MGABHP6kJId8UJRpB3PnUF4jGEtb
         MG5HNB1evV82eRTiVGbbSH2RKm7zFZzcfP+URCcjb8rqFADAKatfzaB44pDOjPmyXGiU
         +VGunI1d5K8nwDb9tqZJg0IY1I00WWckzzX0gY/d8JCOQTPFXtZRojompmnjNJxnpkbh
         2GTwzy+IemMLxrrvy9fHHkepA1JTe3Pm1MGoV75AmFqcopyDURvGwEoXoVsoxQeTq087
         ibIQ==
X-Gm-Message-State: AOJu0YxrVNjPjYgk0P5Pf+6qX80McWU3aEkRFcA1FLqsbJXKg6pyTSkt
	137QpU2QIDmcXfN9tK5MINkkh3X43WcXbiUyJBqRJ+XaNzZ2l190ZTzKB+DzRdeCy56nNdgqL7I
	qbaCn2LTrOYz7XZhEM9kUEhVexEQdru4=
X-Gm-Gg: AZuq6aLdJz9DySZWAwlVLz7aHz779CsROKPEdvD8amnbZ6426yuouPs0d0CwqTpekwC
	h2/U8S/qA0crBVms4daQfMocYTNMdIVhCaBAlT3v4WMzi4/Fu4YdHvfI53hQWv0U7xJ+VmOj6Tv
	5o4es6QXI2eGI2eNFng5WKfDh0jSIH5N7hUXAW5GAbPrzaIkYwC6KvwIY7xwYKADE379NAeZR2I
	hJzCrrjSf8wmOM759yhKGvM4MyGdSgY/en2jiGuFAVWAY2kIZ70ZJTrnuFreMspZaGl8otWJo9W
	X+CT4a2DfVR5U9L26QrK8Fu7r5IDIFOYjECs
X-Received: by 2002:a05:6000:2002:b0:434:2569:275d with SMTP id
 ffacd0b85a97d-435f3a73436mr21241050f8f.26.1770070054543; Mon, 02 Feb 2026
 14:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
In-Reply-To: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Feb 2026 14:07:22 -0800
X-Gm-Features: AZwV_QgHgTWW2vrwerFeSH2Fbd4MYeNulNftp0gea66uCltbg3c6jLbfhmQt8xM
Message-ID: <CAKEwX=MgxrCaLDQp5t=39cXR=01Ac4ktwjEb7hEGV1FiyV9okw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C783140002
X-Stat-Signature: krrd19b7tjehh3khcof4dc5pzqpo54xu
X-HE-Tag: 1770070056-227058
X-HE-Meta: U2FsdGVkX1+J+RySqGdJ4GsBwzzQfS3ZZ6lJGsY3J+tWbRBISi4OuybLDm5djLh1mM0JGnddR+Higye/rszhi/kXk/W4lERhuUeqX7l/qyLIBYIRf0OWrSaeZNkA2HpRDTQ6W0Rq+T4XrbfJ8G5EOIrxmTvEScyqiNDx/YnrKiyDkEnsvUUdjLz6VDIrpp6za29QSazRgTHoUjOiOd0Ru9y50wzA2f8L8aSGg+H2rYeK28KK1hko0wnR1zuVvaq1WoMKsDarKh4pO89VJasd+Sa4dKHTNSkXE7QsbodjAh2rwSIYn8uysuFb0kuxNFBhIajpafw9h+J1HDwK4ezpxasiZX/VR0LMHBe+8zL3MBdFysPR0rjgGCS/hPQmAzLcsKfu1+tAQJSVK1f906lAQjXoQn/sR/af7sD9iRoShQzygm7efP5k0SG4cxLoIElZ4QAJG+vy8iuJ9orrz8+f/vG17gPS35lSJAAM/VGnvuSm1GRftapyvEluAxFtv2IXa08pZLZBrDKTLscovJSdSOndVwiWkR+ddFeKxyZ6/aR4qZ9ZqifEK9bbtKnuTEi17Uzpokzip7AQt9AAgw6CZlSUV5DbJ4oxXhlx3oGDGS5yOAufIiZtJdtOOZF1KJ2mRQGeTsMVxQ6T8Y4hU7XXlRLSe3YtSL81byFpGjm6i8hKOWP5EG22BzN9g2d40oeRWQ6iAlJOK9ifQcEp1/2yubzZ5Ad9uV/PT9ZVaBwJDuPtUfsaXcrnNII8BEfyoOV2vcHsYqne3rVANnMxf9UopcIJPsF2uFzGgB6dqrnd+QohTI24kkZTg2p8o3OiUrRy4d8mmDXKIE0IakH60DJpLLp1mShpcgCjvi4LStoYrjXNRAVpegMEzjIRq5SiWaCQadwiD0TnsNEirZ9rxvkQrxnuhwZBPPMc/7aoveht5FVpGWAQNuvDDJBHmYv0P2p+OsMAWEe2lyPimePTYrf
 h3A/Zint
 71wFgYB7JDlk1kTtzPHudW6THYxSmhMSjSeyaMSjZV5QjhS1Yo7npHiBurGhKMxpZx8jqzivLaZv0Xx78GmdnH/WFXTsBK5e5V6Mx6PmgA/vAkjn+1hBSoBwM+PdjYbfGsr69g1QLN5wNkNJxoUR7MUp0eHs9emjJO++36eOM1RY/qF2n9wzQTbiEFPyta6EYyEySYoMRB9TaUomjU08+rNrn+khxzp6CEExa5f9qApX9opR/RqLXA4dgXmlCYwKqHCT+cV5TanshJKzn40b/nLpKXZPtGwWwMLFxM7e3ZeKZS8yLF8W6wg7322opuMyZ3W7fux1xh8B56TjGJmw9/fQzrei408NSnRwGrcpBsIFcLSKfKxYvTuO/Qfm+hNZB9O0xw9kiSvwesXkIUdnXsYGCcXNlJ8aLvw0qyGlcEXD20AdkY8UQ1dEykjgkGAMnFLIBQ10eKI2Y07PMdDcnUQ86jyy/kT7My8LjraQVQ++h5Ci2Ze5vGMUckQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 1, 2026 at 9:47=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
> cache, including those from SWP_SYNCHRONOUS_IO devices like
> zram. Which means the workaround for swap cache bypassing
> introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
> SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
> keep the comments that are still helpful.
>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Awesome! Thanks for removing that weird case.

Acked-by: Nhat Pham <nphamcs@gmail.com>

