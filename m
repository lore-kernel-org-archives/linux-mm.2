Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B57FD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46E16B000C; Mon, 15 Dec 2025 07:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF87F6B000D; Mon, 15 Dec 2025 07:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5DD6B000E; Mon, 15 Dec 2025 07:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2036B000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:36:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E9BBC01A0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:36:02 +0000 (UTC)
X-FDA: 84221652564.21.6727FFC
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5295DA0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:36:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=flQWsKGa;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.215.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765802160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xa/v4P9haTj4ZTqReHiXOr5VMbg0ab/1utW/mGaXKgw=;
	b=lS3ZgGoo+snueu3OAZuPgmOGMSAVAcUsXYcJ42KW3JbHVZrhprckmuqupc3uQ6XjqA7raX
	OctmIYAEBE19L7IYDw4lwXmA/FYOC6Uu8sD2y02e4UH3UolzccObHAikxKl6ZiaFqH5ySR
	HXDdHJNofWCNL4KAQcXK0/kvxKZmP+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765802160; a=rsa-sha256;
	cv=none;
	b=D7pqPviUI0T47uDEvICPHO1nGJs7rFjMnZ4P1piqUklDMJVkmApwIxVroq96YQpWtzMICM
	3a8PxKipes2ZN4UwfUtPgyj0iDYpz0DNOCzcHFIH06cAihzCmeS8KQXM9eRqUgZaQLZhpI
	HQMikpZ57LC+mTfcPHrzzIM1//h0uMo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=flQWsKGa;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.215.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso2331469a12.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1765802159; x=1766406959; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xa/v4P9haTj4ZTqReHiXOr5VMbg0ab/1utW/mGaXKgw=;
        b=flQWsKGajHTcqNmZn/6t7Kn2REJ61M2t5/AMk/kI9UhT1n5mgCQLUdf0LrC3mzup/T
         J9tX38+r4fLCmAkCyJ5RBca/XURHu50Rt9hl8M3GL0AO+7KK+Vut2MDWldDvXVUPJrAo
         TW3d7EaOhgOD6xyhiiB6T8S4QGO/jfTWfRVcRddB+h2vJ5aFPd2RTV+JbsJCEY6Fu5ph
         6GZJCnLogX0ZeHOgyHZvVy4hYX66cf9FpeK6Q2vpRERv+HWbu+7ZoBusFjsquNb6XAqL
         Cw0b5zNxJIS6V/3OrUGhycDKGuqQyzFmAU07tqFa0I5dQNGITWPcy7Gf9Vb+thprIedJ
         BJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765802159; x=1766406959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xa/v4P9haTj4ZTqReHiXOr5VMbg0ab/1utW/mGaXKgw=;
        b=b1SE5LjLjB2txp9VRAFr7xBBX2p8hmj9XQxgg4cZ3q1oZxtKzugWczmSoEujvWyYYi
         rv+x0bmSZy+UtVizFDylQQHwLI6kPw8FVhmu5zg9zUYIH6Se3oUxilPM4A/z8kFHN8b6
         mSpJAs70Q/9CLn4ZJ6asi1tUkMdy/YWr/YWEFlesChHWxu7y8B1HGuqYYxaKqwRwfafE
         SuKb7Ne+AwmMclEP01c9GDwj9hsN9XlWSfJ1AyqahlUMIHHf8UpFYC6qQaET+zPDCSel
         1NwCCH2A4duWF7qnNeRI0IQ6b3Nnf0x9ZlQg9qHuIu82DojWXM7phJXbXEgYuovlydRW
         KVZA==
X-Forwarded-Encrypted: i=1; AJvYcCX3UDV0+xBHt44mdgLgFZvgMxiN69VwL4Av3KdxRZA+UCF1rjE6Ad8xG6S0BxnersTaii5Xyx2yNg==@kvack.org
X-Gm-Message-State: AOJu0Yzxq1TtqU0iSpO+vtLMLlndUb66sE8GWFZ0zG81X5g/rHCHNoM4
	yUu0qdJV2fQl2hodKbeW6EAtR7itpvtgZLK8M6AbjNRgbfUQsH1CeNflsJyw83Ll5XE=
X-Gm-Gg: AY/fxX4Kb1JuSI6b4429+2WtYzL8f8dUJmvhyfJxYyQbrEAuIINb21cQaX8IXZmiXYG
	PzAvXpSURv4Oyx8KgcTOCklidW8cfdgDB6DXuMR0vXqbM14xVMi1m0ix2Zy6cnU1szw2++GlJxB
	xzAZzCWX73k6LwVJso4QnJsh70Yfey0eaRyTP4ByVQ4YmmzMYtqXYLL+qZ3AJQ+syr2abs8XMMR
	8XGXqY5VH+158xKrqLlv+0WgW8Eq5bRuVT6qxbrfxtfeOLUi3aQBng1NqOsLMDsDgmE/phs4gDn
	vBCb1cvjemJ4M7Ep4vZ5vLl18daZeoz6opRdilhoWPqoCPKAvPfvq0w/nyukWpiZb6/KUgg9aoG
	XWP5t99qXihz+O24PVhQid0Mku+s9JvpPP2AQijMiuSeVic/gaZDEXjnq6lxxX+s6wCkJykBFjf
	91Lq8CreuRWpPbYjJicrorP5CoFLUH7w==
X-Google-Smtp-Source: AGHT+IE4dk/6gfkLnl+zkK4uNzyQFfetkqU807+d/eK6tQfhKPc3OGO5uuhdQtoBZu6M8kDz5ovOog==
X-Received: by 2002:a05:7300:8802:b0:2ab:ca55:89b7 with SMTP id 5a478bee46e88-2ac30158430mr7096429eec.42.1765802158988;
        Mon, 15 Dec 2025 04:35:58 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([205.220.129.38])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac190d3d14sm27968547eec.2.2025.12.15.04.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 04:35:58 -0800 (PST)
Date: Mon, 15 Dec 2025 05:35:21 -0700
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jayaraj Rajappan <jayarajpr@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system
 where swap is not configured
Message-ID: <aUAAidA_0kye7r52@gourry-fedora-PF4VCD3F>
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
 <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
 <776ac4c8-6e55-468e-bb9d-eea49de0ed89@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <776ac4c8-6e55-468e-bb9d-eea49de0ed89@lucifer.local>
X-Stat-Signature: 3c73ctc73ufiqz564hfjniqur1w58exx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5295DA0007
X-Rspam-User: 
X-HE-Tag: 1765802160-846815
X-HE-Meta: U2FsdGVkX19N5wLZBn82IR/kVxd3UnTj1GLW71BUEaneZ5KJi6OehFBoczyM6uMG2HGE6xvNh4tZHLLpRucbXd11YrwQsomPHCBPbCtagvtlyCd8zvkj9Wjb/a/B9wZd5yK1jYVobmy2Dl3EyGop6f9Is7eJa/x12E9BtBNBBoAZBZ9V5fsBI5eVrwQGOER8sl5Ds+EXKSnzWDsaBvNVjWu3laTAkMdBg4prDBQJWYDn27Hr6JUt+1tKNNtW+YjMWiSg6ocwnt296pmfTShdQ66Ka0YGO3j3JUuV74Sb9y1AhXy3LrAgZSGaUgRr/zpbnDDZ6qRpKF9OuSyUj4Z4ZrNoxT/sBJX9AOozFcdiABqDQRilwiNySYEr28JOohQCU8Ef4Swx1tVR/gfPw0CMNYZlYr4N3bF9VKN4vNA2hVbthlNycvViE1bvTF1YU/axhxNp9Ea+41gJqa/f1H3vQ8jyGrjjQj0DV8+am5Lbf1Mvy8FdSRJfeVmeWkkSF9nZyPnDqPMg0GFhup7O2Y52MjwtQXtN476VpGoGSzph+z8kHVDt70WEXUVMLsKWZcU4A4Rw8AblMJy9TrQQf2jdtvByck3dasbPw0yUL4lakhOVe34Onh/SVjJ586Exn6SZInI97r5u0I0hf9qlALh/bPBWR0ZNKktNdObaMDcEPWBNzF3yzeyIUmECscbCsCvOtCzkq/MTF517vtXpJUXtHOHyWZbE7ctuU9vlNYgLszYpdQw4PyAMze4A0X4LcjE0S5AsMQtawqvQ7TCwXwahsVA/SkvIZtFCile6nKV+O5g/IJBJlXa1b/e9yxnvlS7Svi7CJ5H3Niinl1QKjwKMP6Yd4Nr/FdEUoVcBr67TmrYlUTo2F7ERG36ZfQuCB5w3AUHWk88+3dsSLlHdLe7TNL9VH+JmhyTjiar9RzODyLoJKlN8VnJyAaOo2cX/9R+ocbC2fM4anbn4mprgirz
 mMjE+MEq
 kVRlpl/vdDXWGMU/D4oyAiKDC09rcrZ6XBraEjZ7GnAF418H2OBVfvBcco2pHa9lfneMcfgLaiZEXTg7+kkCO4OtJsm4C6Fl5l9I8pYOgf7mO8oXRU959b03Kvjsmzxeh/KjeM1aJvT+rgmybWhegJZpkyVKVU8wB8aMe4O4lWrLbJwqrdgXkUTeiVvNPy5TvWkbRqgJrLqGKnJnL/1BRbClaaafYPmZLv+4g+lPr84/vhKPYTEfkhKP7O9L65p2tmTnMYx8iazcf+Hf+ZmFv7mSxoGOJKCDPCofL146qani9LRDvVswFz12Yw44uUNMsPUhM2MrXKAMxSsoU90mlcvri/DsiltehZG3OfIM0Fegw0CvO7TH7eM+CSjmxDQ7KjYowNCs8D/sdmTotDHC44+0/OQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:16:26AM +0000, Lorenzo Stoakes wrote:
> >
> > s/do_swap_page/do_softleaf_page
> > s/DO_SWAP_PAGE/DO_SOFTLEAF_PAGE
> >
> > No clue what's up with the special sparc stuff.
> 
> :))
> 
> But in general LGTM, obviously assuming David's points are addressed.
> 
> Is this a patch you'd like to do? Or I can batch up with the next softleaf
> series?
> 

I can send you an updated patch this week, just on my way back from
LPC now so need some R&R.  Feel free to snipe it ahead of that if you're
that bored :]

Probably better to bring it in with your next softleaf series anyway
since it's all related.

~Gregory

