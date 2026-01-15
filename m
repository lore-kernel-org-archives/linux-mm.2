Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23915D3CCB2
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB746B0088; Thu, 15 Jan 2026 02:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858EE6B0089; Thu, 15 Jan 2026 02:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A5B6B008A; Thu, 15 Jan 2026 02:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605E46B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:22:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 063B21AF1C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:22:46 +0000 (UTC)
X-FDA: 84333355932.30.87A111D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id BECC1C0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:22:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XudOJ7mX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laRMAzTM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EHOK3G7L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hnIFZBUb;
	spf=pass (imf22.hostedemail.com: domain of pvorel@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=pvorel@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768461764; a=rsa-sha256;
	cv=none;
	b=W6ITABHWnbWLAI4Tf6kBWgwWMHHiHrnfjVelWiGEkWv5UcSzYWORGGkR8wQv70Uc4Ub+rB
	xCzAujKBj6e1Hx87pCaphI91gxa2xpgpR4fN7ccXzp0caMM/GFZK4kDb/xzZhejv8ZbrrP
	1xAxeissoIdUPAND8jbWj1ltnWwAP+M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XudOJ7mX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laRMAzTM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EHOK3G7L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hnIFZBUb;
	spf=pass (imf22.hostedemail.com: domain of pvorel@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=pvorel@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768461764;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlpvlU9RUc1F4iCVSO3rQkbgCwaKD8hJUxYfFKTEWPM=;
	b=eh8Jv9XoA/7nFXuTtJFKGaQsPNwxCbIWuSLRA5HGs4HBjiFPS8iz4M6Y8N7ioV1IW4kpsa
	Ug6mjL62kn/6yITU8Jp49waNQwOsgfQgY1A/+y8H54AEc7RlAS0OZ6cwhQToRc4A7YfU7O
	yfFoJSJR3A9TT+W4tfPkZhf08cOzOyQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D20F333694;
	Thu, 15 Jan 2026 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768461762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlpvlU9RUc1F4iCVSO3rQkbgCwaKD8hJUxYfFKTEWPM=;
	b=XudOJ7mXjnIlMu3K7TB0kagbLb1j6nnRvRPD/IEC0DEoJZdAWPKWq6viZgqjpf2X5VNEap
	Cx6R4BrUaFXl+LF7szzxyk8SdYFXL4M/pMa7opi98bXMR//mtYJUpUBuLrzuwYVLVLhNNB
	FuEkbP/vrzh1iC9/wFPY/VixADrHNso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768461762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlpvlU9RUc1F4iCVSO3rQkbgCwaKD8hJUxYfFKTEWPM=;
	b=laRMAzTMuY0e1xM1KJ0OlxKvtxtI3igNm1eI91cdWd7eQ9S5M3wV8LhKp8vZQkVLlPMwVa
	8WJzcpBCjMt/ZbDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768461760;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlpvlU9RUc1F4iCVSO3rQkbgCwaKD8hJUxYfFKTEWPM=;
	b=EHOK3G7LUt5NFSkL63tRI1gVs6DgtgfLeW9tSWAhPSyJqR8Dpu9TteYq98YSkVWxb2dPfl
	Cv5glKbITvpaCnUMw5WPyBYgW/f3xosTrbA43TNKzE8Jz4Rb1Wl24fBQGSVvLc9CCHS1k/
	CrBgnU+hNvH4jTulh75LGJnARVM4ciU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768461760;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlpvlU9RUc1F4iCVSO3rQkbgCwaKD8hJUxYfFKTEWPM=;
	b=hnIFZBUbDdTh8Jjf23yzSwZRQKE4wan9Aarv1CEz22nKP5qYRqNhnXLw+iH2vLihSYeB0T
	Da0DgR1RIODq1JCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B03F3EA63;
	Thu, 15 Jan 2026 07:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oXj3IMCVaGmrRwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Thu, 15 Jan 2026 07:22:40 +0000
Date: Thu, 15 Jan 2026 08:22:31 +0100
From: Petr Vorel <pvorel@suse.cz>
To: cryolitia@uniontech.com
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Cryolitia PukNgae via B4 Relay <devnull+cryolitia.uniontech.com@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, workflows@vger.kernel.org,
	niecheng1@uniontech.com, ltp@lists.linux.it, zhanjun@uniontech.com
Subject: Re: [LTP] [PATCH RESEND v2] checkpatch: Suppress warnings when
 Reported-by: is followed by Link:
Message-ID: <20260115072231.GA438294@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20260113-checkpatch-v2-1-5dfe8b9f4d90@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-checkpatch-v2-1-5dfe8b9f4d90@uniontech.com>
X-Stat-Signature: hgu5ocjxi51ti39hk98q35kz7gcpgzoa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BECC1C0007
X-Rspam-User: 
X-HE-Tag: 1768461763-517434
X-HE-Meta: U2FsdGVkX19zMediOG5mBOSYGgRES+JtZnSa1YU82OLpgsX/OMF2t4//1+lqP/ul6qF4VcPpXec9P7x6pr5Pj+VlOPyVjwIsrHXJihPMRh0gI9D/FRNcuSte1CA5O1mitu/KpCzKJPUyFEcymoH9LvfxcozHogjNMaLVXbmGqaWtc03BH2G5BMUkkRKtIrp5esiAMqfXVi/SmxXjriNn7ZZl64j2p5IMyyozRqo7MT5b2eKBdO+/StQFlcSOJFUHGtvwuXvHsymIbURozhp0wnuUmWhTbAhZQDuuM2NdXiPrBmBHhwgC5p97/O0yJ6/rnJLtjGmx4ccn6YsPJYobFWtfC8yEYvugiVZhW6rgnr0tak2wyKhyuyFGFltqn4VW5kaR3ke0w1A2G+USWCQ/z60+8djsXBGclV8ivz/e5npjgclUyXj7YTQ077MZNizjAa8ETQtIPJISG6ZLOEJzO8b9gdDxRXUrkwsF1A5oYq0rJZP1sem3zpgQm/2f4sI46v/5NXesI+8gtDllNLBKH9Uv3xPaQyu71o7OAXkf6RnvAfoM/xQvv61f1DT1rHsR4lk/u/frsUMOMrm6zfM7Z6bE/9mQKZDyvc3b4J8HC08xjtCcGwVRDm7HpLJqbCnCj5MHFcm2NDl5+PQwvABjexXrWNSXmOknNONbwAwddxW8dGq1sXkA4WYt8NgMNUjGHgpGpfwoksdKnOBH+bQ5GRk7/hMJRQUFfQnPa3mjkYIK1UlynNStrQNZFqB03tsfBxyCnZ9jZkYE0fNdBkTHTg1agw2EUXUnI+9TwwrukdwHcUgI5+GNiDHKOsXIBBBXZXuarnPFjJEka3aal/ICnyFQYnEFSWulu/FKvlSuL/0Ojs8GQTtFNnlsYuKu99jHbS5oXcH67bLjv4Y7UERGPX9SQDk5mHOBNctBfKLh5JNqrv5mfN5hKj/GlSfuHp6iC8djcnGPm3hwhOzjP5G
 ayQaQdmg
 2C3TbEqQTNo7UCk9Jw5HRjN+ToQdqdFg4tc8MCzFOpo3DOppn8vSVbXO3AImPJeULIxTpZ4a0MxVBqgXXYyM09n5X5YM+Ef9dxyvQdmgckPKNc4WzhZHn09Tt2kXA+5ZJD05FGGbGoy9cTQSi/TAk7oEx4zcypRE0hg4hfktG9mW4HCXybhAAxoGwtUgEot/Udq5D4l1cDX710Y1JHPquvGtlFAob0BRkfewEQiFwnwqi4UQGiF/pr3IwHYdrUOLqZm79nQ867AgvW+d01NY6vFBTMH/1NWU/go2B4Cu0dzhMERwiZ3AmUbQvb+FJv1sr7t3OmsnuzOlc/aqv2FZQl4gEdKMeJr/xT9VBVWHIsNniX/Co1gG9J8k/SoPljCvZW/bEBLaI/byqANiwks/MEJmTjAO/x+UOCRAL0DY8L0wuhiWRErjgSMN/GBH/IYmr6QIOQSGPFxR44aW8eXIj1u8qBBgnR1SKi0ifbj9sZS8Hvpc9xg4wNRh4t7WwTHx0EZmjAKbj54dLAI05yug8pHvz8nspmIcsfHyALWn19YEnILI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cryolitia,

> From: Cryolitia PukNgae <cryolitia@uniontech.com>

> > The tag should be followed by a Closes: tag pointing to the report,
> > unless the report is not available on the web. The Link: tag can be
> > used instead of Closes: if the patch fixes a part of the issue(s)
> > being reported.

Indeed, this is true, although there is a prerequisite:

	The Link: tag can be used instead of Closes: if the patch fixes a part of
	the issue(s) being reported.

Reviewed-by: Petr Vorel <pvorel@suse.cz>

I also see you Cc LTP ML. FYI we vendored scripts/checkpatch.pl (with occasional
updates).

Kind regards,
Petr

> Accroding to Documentation/process/submitting-patches.rst , Link: is
> also acceptable to followed a Reported-by:

> Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
> ---
> Link to previous: https://lore.kernel.org/r/20251023-checkpatch-v1-1-ff73ed1027d6@uniontech.com
> ---
>  scripts/checkpatch.pl | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index c0250244cf7a..dac9d98133c6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3209,10 +3209,10 @@ sub process {
>  			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
>  				if (!defined $lines[$linenr]) {
>  					WARN("BAD_REPORTED_BY_LINK",
> -					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . "\n");
> -				} elsif ($rawlines[$linenr] !~ /^closes:\s*/i) {
> +					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . "\n");
> +				} elsif ($rawlines[$linenr] !~ /^(closes|link):\s*/i) {
>  					WARN("BAD_REPORTED_BY_LINK",
> -					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
> +					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
>  				}
>  			}
>  		}

