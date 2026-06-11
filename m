Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90823CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A5F6B0095; Thu, 11 Jun 2026 07:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11646B009B; Thu, 11 Jun 2026 07:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27736B009E; Thu, 11 Jun 2026 07:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2CB66B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:50:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73E8F1205C8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:50:58 +0000 (UTC)
X-FDA: 84867465396.27.78A7D09
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 926EB40005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:50:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lqt4DXND;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178656;
	b=3Ylsu4M71VDGxs0OJTBfWfkQOOcDuaJWmlI4OCQRpnwlnT/RYRtPEp/rxX0kPCoJu8wk8O
	bJIgYFQTm2VvSfJzpIXgp1kS3MXpEVMw6xUatZkBd3pnzzstQe4p4NnZxbLo0dTvsoRh1c
	QergN1kMwNJ8uyBkxOH4MrR1fN4V9Pc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lqt4DXND;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrzlJyLu9uNWqK5gmAkFzGANXofsBniaCTW8GnMk0r0=;
	b=756QbomZNp+TYVnGKlQURzxEPSoj2a9pCymmb13M+Z/kAMQUIkdkTYqn/iwU+7qk81ClUR
	hrYIBRKwIftrwA/Sy42pjmkLENxM7VI4qwRh8+G8mcaYxGow2bIKSWiUmtr5w/gyACN6jq
	xTA7M55prCG3iGpeg0BDmYwxC1RuyaA=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46066e640easo438754f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781178655; x=1781783455; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrzlJyLu9uNWqK5gmAkFzGANXofsBniaCTW8GnMk0r0=;
        b=Lqt4DXNDGfZvgkHzt/WAGYAbEbTSk4NBSgiKuOoh1/0AkDBxvyW1ms/n5D451sNV1l
         fVUk8zHV5AYo/lQsUbWs7y7sPrJfsSH7q+7EB4jexI8oeFPCHjUVqOvbgx11nIKI+W9L
         qJdXWxEgyQ4Pn46WdYPSPD1DnaCVxYEeN396LVYhcFyhRoYQPRc8SGKwqwKEUUTheCgw
         8kmAUjdapG3ooTwvrTRWY7EmrTjuVn2lmn3mF4jjuOtqm8BCS6cLUoE75gnqkixS3SBT
         8ZZo3fMbmjUXqg7Ykw2hM7mAAklOeTwPaGU18WTsQU+tX6PCPTgPAzG+crhVtBc19M2i
         K+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781178655; x=1781783455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrzlJyLu9uNWqK5gmAkFzGANXofsBniaCTW8GnMk0r0=;
        b=pxNdO7KGv95DJzSgE0U1Vf00h2ZOkhNM4YNv/hxbk2wU7bIWEICPq3EGJBsY1UoXN4
         MeHlHOtpBMMAq+rKPGRk+ffFSmV3q+zJJktTjJ3JzyxVypsZcre2O3WD8yERDsaS5+D6
         ZVxHCD4RDU86uiz+f5i/2vTzBf9fldMgWTywkWZlPs2mrlB3M7lTXWh/bYxxjXDy9OhF
         AKvtOGicQrQhR4rFJG1V7OlC+BFMPX/EhTrzS/GFZHk6GTTj5sR/501Pd15SbAJlu6Kn
         OwSyWy36hAIHvJvf8HBhSfTubKliqBzsGGFcv6FbhL7cBu7tO9zZStD7XP926BNmoq7O
         4mFg==
X-Forwarded-Encrypted: i=1; AFNElJ85a6Ht/AOq3bOCmwZ+6jHmOfHlzuvOg7j+eUL8obhCTD9Z76xgj+5GL7x57B220WQ+F6V4BHEZSQ==@kvack.org
X-Gm-Message-State: AOJu0YxOhSBxJRKuAN11Vrap3EzMc4Wk9RAjyO0wBGZ0nA3B2vIbxZUa
	4LpGfXRuJrVaAx33RpfaVA37s8TWLqGY5blNQceaOE/vJ+I8dL8XSoMe
X-Gm-Gg: Acq92OFXK0pj9kxy0xWUjKD+dX0wgPFa/XBIXIdrKh872MRqGBPEwLg8BK+Ltwnp6VJ
	+Dt5Y8L0inoH2p6TXtAk2zn02obPrD8lPF0hsFdandZAh19XvgL2DFi4i5WPkESnhhv1bJHmocT
	cZ+6gGT74B8ZmPr8QV1jZW8d03T1BHS6the7mh1iJORhYw9/lKL4OPC+gVXUxnxLWkBVmfh5yvP
	tsFbiIARysu60qa5VupwtR94cfvK56E/gGiSFfsJ418OZWdRMfRIhO/qFiQfIKBdJ6kPO39a5Lt
	2redTXVbD0jqZOywnvP0lPLS/aWkQwX3Cy8GA8gFu0I2Y2mzbbyzTIGXbES7EEpvBtrvXTvAAWO
	GycAwjQdFsgE7JiMUhVqYoIRZm36m/csKuYMa0UTTFt6c4c66s35I1HZwYPoXbo81fruY4PpRzd
	hz9aF5STH28ELk30qtaTt+GKQO1oFXZsa2iBFFIvLtpyfnDYwiZM6Ml+eKse0/zbKxexBFhCJmN
	sMRUCaL9z6GKNf9V+OYaDiW3gHqYLEv/9KB+IxR9LLL
X-Received: by 2002:a05:6000:702:b0:452:8286:86bf with SMTP id ffacd0b85a97d-4606758caf2mr3422666f8f.1.1781178654810;
        Thu, 11 Jun 2026 04:50:54 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda363bsm68265267f8f.31.2026.06.11.04.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 04:50:54 -0700 (PDT)
Date: Thu, 11 Jun 2026 12:50:52 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] tools/mm/page_owner_sort: free per-record allocations
Message-ID: <aiqhHE9uROfs_4p9@fedora>
References: <ailAiIKTNSDHkUl6@fedora>
 <440C4C1E0D13E6D1+20260611023411.379986-1-chenyichong@uniontech.com>
 <aipzJR0KnO76crLy@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aipzJR0KnO76crLy@fedora>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 926EB40005
X-Rspam-User: 
X-Stat-Signature: 1du1x8f4xyn933d5tes1z3x8frh99e7g
X-HE-Tag: 1781178656-861614
X-HE-Meta: U2FsdGVkX19aWyUNHR7R3hyVEYQcrykXxCP6MvQjY4/TP0RxHDYG8hofE6TXN1TAUMfyRIWwjaJKBkD1KeJolUHmBGxbfrrxC5miv2SjY10o0ZAUIii6KyB/pgh8rPG7AOf8lo+yS67ffFZqs1MNMd9QYErMnAyJezNjEg+9XluYPMsUDl1E1BX4J2jbyRjw/d9XksTBbpPzYaet/w9xLvR/QYkl228FRWRHun+5lZcLOP2JVkj0IBwEDFuAsQO5TZMMREDDgAIyAX6Q/hVs0MwkMi1T631Cp0AkO4fxvhnH7Vyruzgl1KB4J6ZK60HqAJZzkNH0gxtWcbZ+EzUnIipT7db/gKROstHTnVj5pJ6wIWFeYWr46II8+Imrk+ZMr3tIUSJMnm/eyuWRGu5+Co44tdtd8kRwxB1eBOLaSgN+y5XVOec6khE8oVJ6ygxHqcra0YLFHhdPE2ytuIlqlHxWA3FhJ4VOaaVcDQ5LltSTPs6eqPtzQXWHyC6l6RCCtSrrKCx/xMB7aFa2Vt0BAUNFmQ5pq85blDINjudAp2b29CcY7ur8/OuqseCLRwPTy42iSJG6njo04if+hQ2XIoTyG+6Xz/mo6hpRV+QKc+hDa68kzNVd/CE1+NN/aw2ansaOxYxYNyTEFGQHyLqod1MIjFqqcM29K1ldbLqjz/J7lAV8AcMrazWBXIob4qNjXOmwnv+rjShXRJR7VHzRnwIgUsxWHEnsE/s3VAhu4Gu+5sC95N6DxgL3hZ5kETzoq4k0uCcRQt+8uUX107+1pU7awFeAXbN5hnU4OcGp30ekuyW/uA0yxuCGUQNt+piJkRKDsgvo5HvkAJHJUniLx9Z81xzymWlCfp/vJU73wYR9g/lngxHeYCc/eZ8v1g810kT+jkFfRHK1R9Sc8HSnk7JcChger3AbVTwVXXP5/VXQ3FiRqkXqPjiC5zeEkzkAOosR6NW3ssQ4kyVJ6ie
 YBBt06sJ
 F9VxrONo9IcBOrs3bGrAQBpTuIR/N8D8Ge51JSlNBNMenVzW1ZbKS+vjhb462ZXu9wAUksDHIRXBBvNdKKBhiWgZ9ba+AE1cfV9ZJvY25vppI1ZprwEqst5TAjPJBbVWERmWkUvwb+VUFOymJcXkpdV9zVukleIWy06uOJDiRqAzOVwrUuwREOPiMrGLTH+EG+VCRacfhgCEdc2IU0Jc1LlaXA9HN28kcA1y6AU+vPIm5tOLV+84OBDF/+cxfaV8Ti+6kPWJjiZZBYu6rA9PY++tw8p22+M34AfDz7rJOhtfjH1ZFL6YYj3noiEoYuFhXC6ngZHlx4a69V9nW3tUhgeYx4N74yOAJYuIdQQ1w19gD5MPm4GBuu3P7xRixjuunt/6VRQrZ+lOj5H7qllOaU12MsUz/BgHkZEo6yEvYlaFR5Q6+8N5t7f8c0sgIPjK+wXMX13DiSmTWBzYVU2E39lQ0YvY4y0A4xXleImCPHuxXgdE3Tj9wcGG1Av75HSslF/TyDFFOVtXKTQwJCTllE9uuJZe8pqnMIKQjtv+MznL4KgI1AxfawoFBbGxuWfWi4Bpp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 09:34:45AM +0100, Vishal Moola wrote:
> On Thu, Jun 11, 2026 at 10:34:11AM +0800, Yichong Chen wrote:
> > add_list() allocates comm and txt for each page owner record, but the
> > cleanup path only frees the outer list array. This leaks both buffers for
> > every retained record.
> > 
> > Free discarded records during culling and free the retained records on
> > exit. Also unwind comm when allocating txt fails.
> > 
> > Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> > ---
> > Changes in v2:
> > - Wrap commit message lines to approximately 75 columns.
> > - Use "Yichong Chen" as the author name.
> 
> Thanks. Also, in the future send new versions as new threads :)
> 
> The patch looks fine, just see below for my comment you might have
> missed last time.

Sashiko also caught that is_need() calls get_comm(). That looks like it
should be handling the NULL return case as well. It appears to be an
existing issue, but it could fit into this patch if respinning for v3.

> > @@ -480,9 +489,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
> >  	list[list_size].pid = get_pid(buf);
> >  	list[list_size].tgid = get_tgid(buf);
> >  	list[list_size].comm = get_comm(buf);
> > +	if (!list[list_size].comm) {
> > +		fprintf(stderr, "Out of memory\n");
> > +		return false;
> > +	}
> >  	list[list_size].txt = malloc(len+1);
> >  	if (!list[list_size].txt) {
> >  		fprintf(stderr, "Out of memory\n");
> > +		free(list[list_size].comm);
> > +		list[list_size].comm = NULL;
> >  		return false;
> 
> Returning false here sends us back to the error handling path in main()
> where you end up calling your free_block_list() anyway. So we don't need
> this here, right?
> 
> >  	}
> >  	memcpy(list[list_size].txt, buf, len);
> 

