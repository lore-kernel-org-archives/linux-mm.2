Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C97CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E526B0005; Tue, 12 May 2026 16:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF936B008A; Tue, 12 May 2026 16:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F13E6B008C; Tue, 12 May 2026 16:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDCB76B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:41:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 847C41C044A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:41:26 +0000 (UTC)
X-FDA: 84759938172.13.21621C1
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79BADC0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:41:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WsviX8ZG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778618484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sq67mJ1Mle/Wjax+ZhdINyyVrcamDgHQ2bN9yr1Zbf8=;
	b=xL67JHrpCtzk9pVRwzez0Yhvb/LkN1L6uMPCDZqpOVCPb92l1s2KFWUwxpJYRm18qDbDrh
	VvSqgdoHt5zEzP9g0KlXFU3ASbUDqLi13357a/wy1CEn2gmU1PbsWIGCiwmnRBEJR7vXVT
	j8r2AjWkGp46LzZWOjlJuFzA5sW3GZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778618484; a=rsa-sha256;
	cv=none;
	b=Q9jQT+rtEZWsZvw/LmtUaqFpZS6fkcJfqmQPYNMNSG6MXPNz4hhC1QG/qzKJ0Buz44hWUr
	KHZthTIUL/iCVDCiAt+cbyRS6zHoWbpxif6nZGeo4jlEdKeS5H1+ztZFAffPzIeSDB0Eu0
	CDPaO4yXUyYdAD71WdP5gZQ1c2uYM6Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WsviX8ZG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-90d042fa745so176990985a.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778618483; x=1779223283; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq67mJ1Mle/Wjax+ZhdINyyVrcamDgHQ2bN9yr1Zbf8=;
        b=WsviX8ZG2VbN8c5QbEPo2t4s0AGseX27iPIMSx4MrMo99eHrQ4A19SASk9c9JNEpSj
         pn4QU/PyINfFLwGDyq/bo2eVnLS+neHEdJLVJd9En5HDwiwuRatYQflKLV+iq0ACzEoY
         g3gsN3erN7OkOuaS7xkCxiuUwRJhe8Y52q1e62xBJ02G9FO8FTlVvaNXVKPzfcNrpL7X
         +k2/rJuxyz8a5F8Nya5WYOqC8cyKgFAbgFEGDXveHJFG7ozevbEq5AZ/GJmxxK0dUa7D
         5ahM8SDFDQIztv7TLIMCpeVGJQ3bNB+v3w4BlwlkXippKg8a9jbiGd789Bavehr6trNa
         2XAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618483; x=1779223283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sq67mJ1Mle/Wjax+ZhdINyyVrcamDgHQ2bN9yr1Zbf8=;
        b=TxTCiefsHDKbe10YRrHIlLnMZwaVaM+tSiCoMvO8/FHpY1dGBnCzvaMYsiRr7Wjc4Z
         MQOVWe3W6QEKzoG5Rg+EC+rEwgMSaec9JHM2Z08yG7Xw0jz/jBfk7n4ysPmJWQ7F020j
         qTCKBAI1Vr9B82CEPBSPSZmBzw8eeqZkNJChoGuweEyz/pMx0M4ImOvm/X3a7Vn1EJ2i
         HNZNRSHxuoXYBQbwJsXboQhoe/q+GUBbSXbnyI8N3w2BLc8MT1DSjdWNKhnkXtvdyMd8
         L55jr2dr2s11As8RBNBRQKTzpEBH678AOwR5DQW0hf9OlULUWc2Pc+ntbY7qDNe0KWVq
         Z61w==
X-Forwarded-Encrypted: i=1; AFNElJ/0v2RshXWGm/A39VgUreOy5DPK70/WoIYld/cTBAp++7nl1ob2329QNulppgPE1JlqyDpd5+p2uw==@kvack.org
X-Gm-Message-State: AOJu0YxGjchw+2W9wbSaFkT8xcI2nMQYX0/oXhOhTDk6Znskj+aYzncn
	UFKhJrJz5NdnCGgaN31rtJLWFRFP+McIYGWwCJSKR/yG4wA94ngLwAvIu/HsBypZEHM=
X-Gm-Gg: Acq92OHLVkC4nEJTLLygPOXbzOFwABeUadBC0AtpPllLDxiXk5V59xDDSBifQGJRdSG
	QNlcoCsJxkRl3ukUMhL4s54g45P6wWKL9wkmffezrWt+JgIhQmlAGdVqGdbizSctAUTq2AK+Emj
	hdJiuN/9HoEeVaN/9htvHdjBFca+KhUB0sYzRUHVjAQpQc3PGFRMxhjXQiTtpeQg7Y6Or4BuUcj
	tPf7k2HU1iQzJnx+DrubnXP2IlHuylt4k+FQZOX1MwkDf5zu8vpzSJUu9zS2FiHY3zfcq9jcGDd
	kJJjcix3DYlj1s93xSVbGm8AWQDjaSFzm2jgzwAHXHDjqI8FFSHdpZX0z0KRNrR2eypIqmgYTMW
	/Q/UCthMLEZ5CXim+EPU0zzoIVuYT60h8PSelUiCHY6Kesk/jHVmuB/bQwMglEjJeg8eBFN3XDd
	sY6sAV/gXSVUK4Ld20Bt+7C7obu/hSks9kOjVAnMJfgcG7SrW/0ds=
X-Received: by 2002:a05:620a:4593:b0:8da:d152:b7e2 with SMTP id af79cd13be357-90f88f92e19mr94041885a.25.1778618483528;
        Tue, 12 May 2026 13:41:23 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-90cd7a6c35csm354234285a.42.2026.05.12.13.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:41:23 -0700 (PDT)
Date: Tue, 12 May 2026 20:41:21 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dmatlack@google.com, 
	kexec@lists.infradead.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH 4/5] selftests/liveupdate: Add stress-sessions kexec test
Message-ID: <agOQa0aGZMVRlCu2@plex>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-5-pasha.tatashin@soleen.com>
 <2vxzlddoafel.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzlddoafel.fsf@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79BADC0005
X-Stat-Signature: 5u674w5fhwbry1a34ahn86sp5c6cfwcg
X-Rspam-User: 
X-HE-Tag: 1778618484-54505
X-HE-Meta: U2FsdGVkX1/StQfkadMdlng95sg0aVCBrI3AkCNbtpSaJHwnlJC/iaDN20tkzTHjj555qU7uiSt5KHmZfB3F8dslenF/tU+LzTDp/USmFFMOiUgEbvm+YAf1EmtYtYEo0ik5OBBDwPApzrDO+b7yyy/sPLZrrYY8E4z5JRaj8wyiRC84AJM8pZRCgs+yjIrQm9ezV1Zm53YRjOVzuL0YbG4KHD09NHfCtbJNSeccDm20wCiuFH/XegWuvmGJ1jXR+tgU+0rFbd6w6ruzTKgZ4/Lc5YwHbfDOl0/BnfuotpOW+I8/tXpvnFug1W8rRIRHyjpHmVUUr/iFTLt+B6aMH0jS88qd2tykQxTbJGk7J577ScFJe11Te8qAV+/3AgsBMB6wED+Dn2iQgYioNmZEkL9G589USvP4bpDS6mSwkKKC3Tv+aW7xgRXdsM1Y6lRdy96kW+WM3npXD+19e23rt0wtSO/0VQ4BcqVMScDs3rYiCVO9ovE0N8yGJLqD6HCEXE8u3sL6SdrsT6RInypv9oedNwihkUTMGjrzZHNvCr9f46DKQ4fbEzahK9OODeg83OlUSjPKs4K7PBuZy/de8+tri2Ciiw/NoSjrIanSSCPainr5c4yw0dSg/GlB72bS0gfAo7ecBpt5f1tSKTSObQTAKjAvbr5EgPtCBeUgKoyLav6OeYFwb5T1H18EANkchpcaGPX0ISI+MeCU5tyFhD7mjRWZl/EYXtx0Bbxuy5AykahRq3YjuxNeaBlz/PCE3RR2hsQVZFnBNgQhvHiLAQbptYZpVz+ZmbirtQxIxlj57gUBG00Vj08V/yGLE7edNoFsuxZivkSxOy5m/EiBNahGwx1gzrNrmND/ImkanLG1GRlzrdIH6feKDNJtNYSJvdsycDJzb5HWvaM8iMXNq0fvtvYDfOr9MvOlXCRIFF3d/pD6G3fQyda2Qyf9Iqlu4Ii+x9YkIOUvYPBmypk
 NBZAwFn8
 aeZrZ7XpFDKieQazwNV4GxmaR9v2wLfDL69sTh93mCoYJAwwrp1anslg808VyXhp1VtltJqNcbzg7HZoKnpm/GF9+am8daOsBn8a+Q0aavTKb7pQU78SzKIN6TsCDA2XCnHep8pvRGF/bT/9iOEHL9CYzqnpyahM5MvFkkcbY1WBRodXkYkuoBMBqoPmEzEZNVUNILpFyI/SWKzHm4taiC9GrnJsPfer2ad5+8cQNKCVDL9SgzRV2gj6TWMn+dFw+SClcxJ4KdupaVodYlI+JYC58TGA20bbCoGSXl91/MNnkloehmAUcT8NqUJqJGserPoMCGhpH2jVqr7PaE5KVokP8wJ5MyQFrdbYeOZRJYXhsvibWOuDpg/9p9bXdCbUEJdE6IafWDZzdSQQhir+cYUHWp1idyQ3ErssAp8N53yCkGHgueksvgUwHcBKx7qGPq612MQh6lZhr0IXuvBxwcT+TAZ8SC3HNGEMlMzosjYpifQuWZ3/qVWZitw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-12 16:09, Pratyush Yadav wrote:
> On Tue, Apr 14 2026, Pasha Tatashin wrote:
> 
> > Add a new test that creates 2000 LUO sessions before a kexec
> > reboot and verifies their presence after the reboot. This ensures
> > that the linked-block serialization mechanism works correctly for
> > a large number of sessions.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> > diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> > index 3c8721c505df..37c330b9bb36 100644
> > --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> > +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> > @@ -20,6 +20,7 @@
> >  #include <sys/stat.h>
> >  #include <errno.h>
> >  #include <stdarg.h>
> > +#include <sys/resource.h>
> >  
> >  #include "luo_test_utils.h"
> >  
> > @@ -28,6 +29,30 @@ int luo_open_device(void)
> >  	return open(LUO_DEVICE, O_RDWR);
> >  }
> >  
> > +void luo_ensure_nofile_limit(long min_limit)
> 
> Since you are adding this to luo_test_utils anyway, I think you should
> do it in patch 3 and use it there too.

Done

> 
> LGTM otherwise.
> 
> > +{
> > +	struct rlimit hl;
> > +
> > +	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
> > +		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
> > +
> > +	if (hl.rlim_cur >= min_limit)
> > +		return;
> > +
> > +	hl.rlim_cur = min_limit;
> > +	if (hl.rlim_cur > hl.rlim_max)
> > +		hl.rlim_max = hl.rlim_cur;
> > +
> > +	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
> > +		if (errno == EPERM) {
> > +			ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE to %ld\n",
> > +				       hl.rlim_cur);
> > +		}
> > +		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
> > +				   hl.rlim_cur, strerror(errno));
> > +	}
> > +}
> > +
> >  int luo_create_session(int luo_fd, const char *name)
> >  {
> >  	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
> 
> -- 
> Regards,
> Pratyush Yadav

