Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C087606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zjXxQpVb
Received: by kanga.kvack.org (Postfix)
	id 38F906B00EF; Wed, 11 Nov 2026 06:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FE56B05B2; Wed, 11 Nov 2026 06:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DA16B05B3; Wed, 11 Nov 2026 06:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 030D26B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:29:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 999A5A7B26
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:29:34 +0000 (UTC)
X-FDA: 85422617868.16.4A4E1CA
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id BBFF316000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:29:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zjXxQpVb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8gUr6YQpOMRYWSFdHxvUy3rBFE83YPVYbXBV1p9Los=;
	b=N1CvYz24mQp2kAuQ1DNQ0iOiVNrh5VBnM/V7/0G2qEQlsx5gOucGVVbAY/HQekcYaJ2Vw8
	dzXaaz8GGrnadB9f7w2Y/tU9kJunbWQg7+JMx9HtqCDVCD9HVzd0U2p1s5ePZrtOxo0nYP
	lTpNoECAprICz0t7Bt7nJ/R0aRx2J3o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zjXxQpVb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396572;
	b=x8Mc+imQahalBl+dJxZ67BEDG7dDLPnlBL+8rpk+XN0TZTVgyv91ZItdsqMsOU8jCrxpxB
	rmBE7/8jRSHenYEigy8l2IMKxpjyNj/QxDg/+37Y1Ce00hwsp/ISj4QPRgngp3XwlaMa9I
	1PqWZWi/plfEOyEj+QMevxqpzKL/Fws=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36dc4797082so60754eec.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396571; x=1795001371; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q8gUr6YQpOMRYWSFdHxvUy3rBFE83YPVYbXBV1p9Los=;
        b=zjXxQpVbmJvhhMY1O5kBFbzVUxQSO4ylCyt4huKIN6eUqWIpe6qSWmxeA5iMsKyPtG
         jz5kG7lPARb6xVIDUAMvpbcsidI6T7taINe2Ju1k4s08hKbhQGODt0buEdjm0tIJeMPd
         cjTPcpUTVf8bv7ewyn18c8giSIfVSOhzMIC+f5cM4OcSf4EJ2zK22wTNJRQcFDTNHNCr
         Y9MJqzlSo2/wl6nNXUL4/gDrsWXDwKcx7i/6XfuJgm8bzhc48ceHMrKaH9wWkUNk23uT
         bl3OUKT/rHpP+hg8ePqUSa5WDTAwDAOsih7Vk+Of4K+sv7ZAJBGHzO68P/Q8+qKFFcpo
         Zw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396571; x=1795001371;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q8gUr6YQpOMRYWSFdHxvUy3rBFE83YPVYbXBV1p9Los=;
        b=zTvuyPjrbPAsaY/mnN1aGKYH3+6TklbKTy1Bd4ZVnJmdCab8vhj15smMKnBslD4ipo
         rOpb0AbLJfBnWw4onp3CZejn3mAu/s8zH29xqB1EvM7rcmY9z4rPMdv0fwKsiEkZ7k4w
         mnZccZkzbgUgHpdZNcCo3eCKx6QO3tiJO8GMLnewTErcuhAWQVR+bKQUo8vCMMvpBTsE
         cf9GruTcVROLwMv+mcGX5rWYytOK8G1XGVoCqlvt0OqxUm31pObHz07IX3lTfRy7xJx+
         pKzHT80sL/ZP/9LJLjUXU0Pr5A24Tuu0o9U/rctLEEBF/cK9gZbbXOFS27EI3+Hjl2Xa
         MCtA==
X-Forwarded-Encrypted: i=1; AL+hErHSyuVWZOzpqEqXjhG6aGnh8IhxZfZ59TigalYxmci6QDrCXxjGRAWFHP2rIvChtfYkA5FCc6AD5g==@kvack.org
X-Gm-Message-State: APuU4Z98YGlhfxtxWu9+SoFv72w1+Izi6QxYTyl4/bK50Q8H8kTL62cv
	BgQoo/FLSPjjZnj7w+vFLn0RJH5G7HeqmCaOXd2dEexhTs/3lOtkaC2C
X-Gm-Gg: AYBFou3tTI2BtN+rMkgzo4tgGfb6yXQwCZSO3qgcvSRU93LnyUhJWoK6oJ9C9aP4Miu
	nfO88xne/3BqKsPhEU11HtQPtTZ3zLY2DfcsgQYANGXu6Ercs/SNXo2maXlFQqRlo95aJ/4ntXk
	Kg+HxFiQDopAZ2ZpkVBPbPJBxUsrgTlrSYidt3ZE88Egw0mhX6DW4ZDvupEK+AZGV2T/5QC2Bgw
	FML7uCukAmmhkyrOXk6Cch3/xMzjYpxG1fYfhQ0eAMGWGsOX+5nmn2M++WLjq/NQyFFvxm2rDnw
	wZNrxsVDtYpSyRcJ0Zr4Ilc5ipGQp1MaeV18BrTQTMnLyA9f5OpPayLW2wqeRkkBCMk+IqVZBvM
	S8sU+jAb9HUQyWJVx2JtsWsMJHTnsRSVmvJVJ7is9cyfCmfJ/ff4K0JEdduyPiHvGek7/UhtVn2
	f3pcXL8amJ+vGm75h+7pQLXDj05aHNZyW/o4RUN6ETIrAjXzzFyiQsi7INx1X8Pg14jLhm+sYHG
	ZAj8dHbKT12YH0alNi/98Wu+QRFNDlvjH72/814U3q2vte7oWW1LgJndAn2+CzMCgaGjMJIZPhe
	H0zPHhl8uJYpNFhLuaSWFtnDUtlyZnvsgODN+M6IzmryqP77SbKId35Mp3qt4zE6qfs=
X-Received: by 2002:a05:7022:5f1c:b0:165:be2f:c56e with SMTP id a92af1059eb24-1b3c02e9530mr2733676c88.2.1794396571126;
        Wed, 11 Nov 2026 03:29:31 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11346sm17527411c88.7.2026.11.11.03.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:29:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <avPwLHMalD_kzD-z@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
 <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
 <avPwLHMalD_kzD-z@google.com>
Date: Wed, 11 Nov 2026 19:29:26 +0800
Message-Id: <179439656670.2142163.17566683934241550445.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBFF316000A
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oem17aqrpxbxnd465rtyahd4ka7hmyc8
X-HE-Tag: 1794396572-628803
X-HE-Meta: U2FsdGVkX1/qtWXyYGaIjE4wPdGZYoCS2B6P0cUWxwX6gM+oHunQ8ZcSfM0s8v7LZr83pUvWKaQe60GFSod7fcco71lS8li7hopx7lb3nj5S4m6+TTj6xnULPSMpEa/rVAnj7kK6wJo8Tsx5QG28f7BbO+QqsDqKzc/NYBbp9ucTpcZNmdlBmbrmE2rycQLNQ3CATXIyxguF05QR8vbHc3iGbbetUi+x+9FIbvu3WlmXq4m4AWFG9MfT3MaowJgWqEL49LFyNlKyxCdX5wHlmlqoOT+6sPb6Mv1rAEn8LSpmazBxSYi3lZtXC1mc1VM2AiFOXPpm23rYOz4R0kYbHdtZBwqwaTiBthArlR19ydaMjqqnFA/4xFjwMtv/GB4hsUqHIxff9RV35kNO+35fbouLT4Lkgh/wFsg14fFzgdqDAb44aG6TMRTF21n07wCqJJ/NN5aLHFOyDIe+BmdPdBhlXGreY2Wjh3rDbrTQOP7/br2gx3H8nIQ4uV6xWOLQJ6fV6uluv/ZeiOksMHxtCuLRQyUm5XUsgV4q81J0gamGhDdM1z0RlJ7wAR9K1MXVij5hR9T1BwanEPTb4XJCH/YqhOEeMNew+1Y3bsyNpdlx/eM9Y5+062oXs9vrYl6TyETm98NsvfEUmHRvvYqgt2FTWMDSB2Ao7wesBObk5kD7EBgaPD5B/tNvEGbkMGbO5KLJPs4sKYMNcc/QyV8ZpKpBxcr6AUMrUuJtnpSQCXkS6tgOsNB09F5t/KTAck1DG5ucqHEmJ2GA0XkPbxp61nR5iJi+mKEME9LQFcTpyile1yPF5ebTgE+bA3ovpcDyCMoYnwBioX8BQ7YHRmcvE+gpL7bXf815dwi6IcDmmplDy3sUpXcAO5Mr5Vch4W7CnFhGKZjTyc+irnyxnaFnGPEHZXxyAp7BOA0Twf3iVTgyfKcko8zIqZGfJXHHpIOp963KEhzE0+XN9oNLKe5
 qiFgvJFL
 L82XrUCXj9YGkqATZnWMql0oj0WdVkyRybzRJfmzrKAEWqB3yc+xkZpWpNo5nXbFb8dllcU0HquLJYNM1v5ZlzceS/y85LUG09eMFy4C0UsMqU2mzRUzzv3lvh9AZQYDBA4YS3zjiIlsJhctZUG5tdhRSOFZkzMSvpNt4AXMWa6GKDPUes/3L1lEEQ4l+5MIOUBuPA9T6ClqHq7ViuO5s7SL0zpgZKOcaSNQFAKyDVieN72T5RQufb98pAdy+MTmLJX87fEZ3OTZF78td6YWmAtuBtlFpxYdffBe3AloJRiaBlzp1z4tiVORpPeH67HMNg576A9chPfACNi8zexGpORyeIJZ7q2bXqjuKE/FGIjuEkGA9JmKRsyjy2onW7aAXl6u6ZGPuKAmn61VanSB6H58N+IXgkcXY+ONfREPSO80qMHPchk+W+lohCKFiVbbfsHFqIyrSYOwJZ18IZ5LFNifSEZNlvJpdlYgxSnamSAhsxjjQ6W+CJX0ci1JdUrrGfOu08pacuCuUfrkHoLQPve09hU5HplITVxHBV8hcnGcbNKY1N40nFryMZzK/jBw/L0tCZz/o03IFVEclwpF8mxYp/AE+Hg4DwU9keTKTH6FU+6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 13:35 +0900, Sergey Senozhatsky wrote:
> On (26/11/10 08:00), Nhat Pham wrote:
> > On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> > >
> > > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > > counters are updated regardless of this option.
> > >
> > > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > > debugfs is unavailable.
> > >
> > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > ---
> > >  mm/zsmalloc.c | 33 ++-------------------------------
> > >  1 file changed, 2 insertions(+), 31 deletions(-)
> > 
> > FWIW, LGTM:
> > 
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > 
> > But I come from the perspective of large(r) server machines - I'd wait
> > for the feedback of embedded folks too :)
> > 
> > Sergey, how do you feel about this direction? We've run the stats
> > collection (even before we select CONFIG_ZSMALLOC_STAT to expose the
> > stats to userspace) for eons, and it was never a bottleneck AFAICS in
> > our fleet...  And the stats files seem trivial, relatively speaking?
> 
> Yeah I guess I'm fine with this change.
> I think this can be just one patch.
> 
Yeah, Nhat had the same suggestion. I'll squash them into one patch in v3.


