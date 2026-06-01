Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52AFECD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D1F6B03E5; Mon,  1 Jun 2026 10:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDD26B03E7; Mon,  1 Jun 2026 10:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACBF6B03E8; Mon,  1 Jun 2026 10:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8869D6B03E5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:44:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F64A1622E0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:44:23 +0000 (UTC)
X-FDA: 84831614406.05.32DFDBA
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 559D1C000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:44:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U1UqEKdI;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHCECJLKZVXmKAb51dyXN6SjQcWAQtdhT5+Tc3oFsbc=;
	b=IX3sXnAf1FX9Yax/0swWpjoXGmvTnDILhSV6EwYPqX7ejX/Y5QSkd8PvJ/QGV8Bug3RgOO
	rVvugTCH7xCqu49d47t9y6ifyRRbdCZvIRyU6YfC+WtETLdsCl8XcVVxBmMNISD+/QN2aI
	imPDdQa9be5M2zu7gjf1XvUp/qxMrfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780325061; a=rsa-sha256;
	cv=none;
	b=tyZzv/wpu1x6oJVbobxdmkZpxPh5WktdgXjvTfulh8WqSJNYdMB484SX/yvtQEgHKtIsU/
	18OT/P8Rf0+BbMjeR2ZaRK/9SPaeYj2zpGXPtoZ3aoO78a5t8QxgW6sUZdHmOVs4zPp6Dz
	FMEnRvQRgy8j4ICm5TuYSAatH6LQtVg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U1UqEKdI;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7e38f2f3800so14876267b3.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780325060; x=1780929860; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GHCECJLKZVXmKAb51dyXN6SjQcWAQtdhT5+Tc3oFsbc=;
        b=U1UqEKdI5QbkI2+1CxMXfeX+NUTk3xFoVkQJnoJAUuiMYHy0Og4Rwp5JONa980nIVg
         tyvQwa0wWnqgWtnSEmfN75Yx3VBq16R0u/gvIGHEjC5u8t2jkO5uuv0s+upr8vt9oPR6
         YXgrW6UpgT8osmYe8PK5dvf5akzegIZVyYM1UadTTmpRtvW2LynY5CbjCNE1nEmkrtd2
         KeDFsatFK4/p4AfCFt3fDRYiw5ok+hSZxeUQVODcgnxA8XSMLcPUTsZ3/CUJAp0bNYSR
         ulxbQMFqofdDMv5olzzXEslfm8N18rRA5jiIqJE0sQtumloMsbQz3ZU6wdODMhSuDZJd
         i8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780325060; x=1780929860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHCECJLKZVXmKAb51dyXN6SjQcWAQtdhT5+Tc3oFsbc=;
        b=QY90ywerXsrHrI7LTWosc1HUjg05w3NOkNdKyBYCmDV4lnVmq9Tqa76c6HqnfpVQ4F
         Hi1Mbvkuxz5m7ZCeuFsP4pnGWcMQpvhc/6grhzxapSQLJvcGC8CJUV1nRla6zvDhY/qv
         OsQT+jEs704pEqhDz898vqTM9tN3lFHRhSmYsF2xnnql99oT/tSNZ1hcEKkpXuoqc7t2
         DOnKiS9Y12WzOk5LJoYy81eszVG4HmYPOApVn9CDzvknR0Zm9OURKMD4FuzKrcnuLtrz
         NL8q7/go9nakurnCrDuqj549irl06jOEsnOB5Nh45q5j54/gZmaANh9r5J6obN+CFaiB
         WoxA==
X-Forwarded-Encrypted: i=1; AFNElJ8DGqL/sI8+vZkiXY0uhy1mYtCb1dmYPm+BacDASEG8oUWdlNWTz6E8iO2Lc/AmL6xpfIh2SiN01g==@kvack.org
X-Gm-Message-State: AOJu0YwCuvCFm3ohwAvGR9YDBI4Xjm25ND/XwetBQK9AbRG8QW17Hy1n
	7lvIZHdGRC4+ZDdQMHISwCoBNIh9tvkCoC+Qvug1BudZVtczv0CbGOXHqA30ovwvGkI=
X-Gm-Gg: Acq92OGuOpeZFsIkkO+/eAvvgkdje9lXOin0ZU0nyjXY3QzVuGfVfW7mXiiRnEc5Q2S
	/JoNs8UHhzyDFsI4Np5mFIcwaMW1C6GYlYrICGPW5yA+q3h37qbX/FmqLOACpypC2LrEiuQnkYV
	NgWrCAV1pe0l+jvKCiKT0BVgfqehXrrtbYftLzAknn62PQPBTRqCzRmbXeFgwHB0NQFLkgXHEO3
	svSM7+ahoWrDqLx66+aYgxGi7juNZxVl+p9hjV0YDOqnDEouK69LrJMD0D4VIvQq5e1cMA8D3jZ
	b58+X/U31vVypMhLko66oIZ/vhDT3ulPNaH9RXTuSmqLN0UV32MVkQiMljtyIX9ee/WKu1yvFib
	kkvTbnkEW4j81jILwvqPqxdxJ5ox+QCusYLMZ/+oPRgxYajO3cxM6T5MeXr0d50xz3Y18hxFb5j
	dYQJ0lpaOTJSw114EvsCBy95CD4hKuKl3xg9rQYIhdS2MOjIEd9rjR49hqjPgcUOau7dLbqnB1K
	kyziJfhBqSCps3Q41Ow5BDluJVaVakLK4su2kSxqADiZ/yZw9YH2w==
X-Received: by 2002:a05:690c:3511:b0:7dc:e580:7f8 with SMTP id 00721157ae682-7e05d0172d6mr107595267b3.26.1780325055588;
        Mon, 01 Jun 2026 07:44:15 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7e17c9ac78asm41186257b3.43.2026.06.01.07.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:44:15 -0700 (PDT)
Date: Mon, 1 Jun 2026 10:44:14 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 09/13] liveupdate: Remove limit on the number of
 sessions
Message-ID: <ah2ardT1UjymdMqd@google.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-10-pasha.tatashin@soleen.com>
 <2vxzfr36fjcj.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzfr36fjcj.fsf@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: xc7eumw46wkh54uoi4eik4prncspd348
X-Rspamd-Queue-Id: 559D1C000F
X-Rspam-User: 
X-HE-Tag: 1780325061-391830
X-HE-Meta: U2FsdGVkX1/SzJRKWXVdk96f1Nm2/rUpp4LVfcDK9YPH7f7bExeXwlyeEQTm0bn99ppBEzSMUrCX7s9EV+M3mbkOTMkREKTn+PGfKu/8pi9g020gzkLg7QzhL8UMgbD0typ/AEIvshpu9SXNOZ3XQx4mtZ1IZTvGDrLNNsPPB4KLAGeQTQHJ6EpO8/GtHWZQkKow/DoiQFhmVEA4xdmRFxJ8/cQxsW0xXXQCkX2Bcrv0dSTStc8GhJf8Z//wbYPldKB9RQ52PNBABJ+DevPvMvgnxCWRqIrlPKAeCCZOWZZ03h4qz79wLKVp5itkFvrbvUSNyeJDPqubXUN5cGMC8Sr21HotKnYoeRDjb8r6y/2iCPYsS5mYq66q8HBMd13EbzTE9ZTL5mQAc+9e/mV9WSy+1JLZf2+BD30u5gDQ2gIhQf7J2sC2hHRJhtmGdsYxiD1UzYK6Hr1jmWfM1FViZjk7iebpToALCqsqST3tGaRP6UgAzHdI1s0F28SUBtoOdncvU7BfqRRN7YL9913GpJFfUwl3Og4jg8FCdxBmrGEoEJZyg7qxOJctPecobVWYOBCRLn1EOjY9ORCH0dYwMNSoE+uwzgTuYKdA57MBHdK4v2cPpm1KYlrSBSco5xgTc1bsUXr8QrTgsBDY0LHToq94nHvr6S0EjHQ6ASVZsZMF0pxwAMfx5teuaYzmw2hCtLWEQL+Mmqd5GyNEIEbIUrwS7s5blJJ79scZcsF869uaaKPW9IyUMY7xvhRPblheTe1+85SJ98i8uty4P6TLPO5Zt7Hfuf/i8lGZ3MLvqxeF9C20YjWXuwJmcyK/SfoD4Txhbf/N85ifM2rHohUNyil85yiW2zjP3iJGe0pob8ZCJWKL6n9dO0dBzP1WMGeavkQRVUNdRuJ1IeATw7aGv+gS2hPxxNHIr0PBxbOQrQmYm+PKozFTxelp97ufdSvJh4YuACUODP49QdLXzKn
 vfTBwO3v
 NzaZmXNb4TYsUdAsU99gOb1O+Vi8vwkgIhOrxzbESz0MpVBZ/KcB/O+WgPiNi6UNei62hERRpvtY/7dhs2dHuNArkVYsy82pF3LXZ+aY9vjHtnCZcDmvpeO71y/UbdvZvMfibnpBP8TAbSl6XbAsotBHilGjzVtjZDgtIOujwPLlpdudHVaYB/ibru1nmzVU1MyjE0/tDeq+KfUagh7WtWQUnABJys4DE0pAob2qLZdUKPIrrekYxtKiecOnYMduH7HiItC/M9ZFonT4vTPGYibH8Y/dJPtW0T/tQco70K6WBF3w/ePuamjT2un+C7cNwovSIpe+s06WtaXHXDt/DJyVclo0GaVZY8NgVYHlr+x3D1+8Exk8lEnr72UR/hN7X7EKzh+yYK+G6+hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-01 16:03, Pratyush Yadav wrote:
> On Sat, May 30 2026, Pasha Tatashin wrote:
> 
> > Currently, the number of LUO sessions is limited by a fixed number of
> > pre-allocated pages for serialization (16 pages, allowing for ~819
> > sessions).
> >
> > This limitation is problematic if LUO is used to support things such as
> > systemd file descriptor store, and would be used not just as VM memory
> > but to save other states on the machine.
> >
> > Remove this limit by transitioning to a linked-block approach for
> > session metadata serialization. Instead of a single contiguous block,
> > session metadata is now stored in a chain of 16-page blocks. Each block
> > starts with a header containing the physical address of the next block
> > and the number of session entries in the current block.
> >
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> [...]
> > @@ -63,13 +58,15 @@
> >  #define _LINUX_KHO_ABI_LUO_H
> >  
> >  #include <linux/align.h>
> > +#include <linux/kho/abi/block.h>
> >  #include <uapi/linux/liveupdate.h>
> >  
> >  /*
> >   * The LUO state is registered under this KHO entry name.
> >   */
> >  #define LUO_KHO_ENTRY_NAME	"LUO"
> > -#define LUO_ABI_COMPATIBLE	"luo-v3"
> > +#define LUO_COMPAT_BASE		"luo-v3"
> > +#define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE
> 
> That's clever :-)
> 
> [...]
> >  int luo_session_serialize(void)
> >  {
> >  	struct luo_session_header *sh = &luo_session_global.outgoing;
> >  	struct luo_session *session;
> > -	int i = 0;
> > +	struct kho_block_it it;
> >  	int err;
> >  
> >  	down_write(&luo_session_serialize_rwsem);
> >  	down_write(&sh->rwsem);
> >  	*sh->sessions_pa = 0;
> >  
> > +	kho_block_it_init(&it, &sh->block_set);
> > +
> >  	list_for_each_entry(session, &sh->list, list) {
> > -		err = luo_session_freeze_one(session, &sh->ser[i]);
> > -		if (err)
> > +		struct luo_session_ser *ser = kho_block_it_next(&it);
> > +
> > +		if (!ser) {
> > +			err = -ENOSPC;
> >  			goto err_undo;
> > +		}
> >  
> > -		strscpy(sh->ser[i].name, session->name,
> > -			sizeof(sh->ser[i].name));
> > -		i++;
> > -	}
> > +		err = luo_session_freeze_one(session, ser);
> > +		if (err) {
> > +			kho_block_it_prev(&it);
> > +			goto err_undo;
> > +		}
> >  
> > -	if (sh->header_ser && sh->count > 0) {
> > -		sh->header_ser->count = sh->count;
> > -		*sh->sessions_pa = virt_to_phys(sh->header_ser);
> > +		strscpy(ser->name, session->name, sizeof(ser->name));
> >  	}
> > +
> > +	kho_block_it_finalize(&it);
> > +
> > +	if (sh->sessions_pa && sh->count > 0)
> 
> Nit: Why check for sh->sessions_pa? It can never be NULL.

Good point, I will remove it.

> 
> Other than this, 
> 
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> 
> > +		*sh->sessions_pa = sh->block_set.head_pa;
> >  	up_write(&sh->rwsem);
> >  
> >  	return 0;
> >  
> >  err_undo:
> >  	list_for_each_entry_continue_reverse(session, &sh->list, list) {
> > -		i--;
> > -		luo_session_unfreeze_one(session, &sh->ser[i]);
> > -		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
> > +		struct luo_session_ser *ser = kho_block_it_prev(&it);
> > +
> > +		luo_session_unfreeze_one(session, ser);
> > +		memset(ser->name, 0, sizeof(ser->name));
> >  	}
> >  	up_write(&sh->rwsem);
> >  	up_write(&luo_session_serialize_rwsem);
> 
> -- 
> Regards,
> Pratyush Yadav

