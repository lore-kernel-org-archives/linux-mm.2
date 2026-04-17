Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119D8F99C60
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199C56B013A; Fri, 17 Apr 2026 16:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A856B013B; Fri, 17 Apr 2026 16:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060F66B013C; Fri, 17 Apr 2026 16:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED5BB6B013A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:34:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81FA41B76C6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:34:05 +0000 (UTC)
X-FDA: 84669199650.24.37E4EC5
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A789120006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:34:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JziNEL0G;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776458043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mDgag3heI0Xq6cOwTzAN2kLoPD+3ToO9Xg13RSbuGo=;
	b=Msgh6MdmPDxGGLg4uAOpXY0ytK9dVJ9mNEPOtWZ9RWwrgNlS6iCsbw4VRAWWq2nWR2n0mN
	rXsNOsInFz49+nATgBJ85sjyQu+UTFphmdEZsrjGvWKtDvhKIn0HRdeby6UFJSRPawsROT
	Ql3P+wZqJKimZRU1s3h+tFufO3JMUeU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JziNEL0G;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776458043; a=rsa-sha256;
	cv=none;
	b=q7iE/tsXSiJE9YTGEzApcj279bTA3xruzWuQA5TRNv5zUhqM0NxPVIpVU57Vuo8SuQEIL4
	8cgXB8uAu3Sgces46RWHvrNkeYqK8ve2f2PFpC+Oh8a++yZ9k99xLKhqZ/PbJKOPoQoeOw
	5EZAIc4ZwW4taG/xiEDGH1qrmyPHBs0=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a032383008so10661556d6.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776458042; x=1777062842; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9mDgag3heI0Xq6cOwTzAN2kLoPD+3ToO9Xg13RSbuGo=;
        b=JziNEL0GvfRHBIRmxQsBFCZF1PKv6hbrfhm0LfQ95rVkvX8ieX9hbLhkFXKLkTY2/x
         Rs5/hArDVAsfDVvnfk7/Y7lG88grTulfb74rHp1YmH62BWus3rOo42hggb5OnlmgdlfY
         YEb9KGtJ4wRyotNy3IanV7YNGkg727UW8A/gJ+Z5YbT4FZ7c2hYJOQZJxFRQqD6PU5cv
         /DgXVJrS192wEoLmBkdpvSRzmXhD34QIkSe1w+ggSWBkSkmV441abjulN6GtSYBNqyXf
         I/cJBZ3IMpZ7KqzwxjBvguMTRNYg02G7Wy4242JQ2rfHfcVvf1JkiM05DtaqKjqiKkYv
         f47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776458042; x=1777062842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9mDgag3heI0Xq6cOwTzAN2kLoPD+3ToO9Xg13RSbuGo=;
        b=pH1aI0h2kwkdpWHLLCLThvwcoAi2yQ9XrsEO+k/QWW7W2/wYAHT2fu6NRTmF3MwKPR
         7u4JThN9uWXU9e+UNFp7s2BZvAi2O+HVkgBJg1DFUh7qGQ7Mb0WpQF2EOMLUSz32xmc9
         QXBV11dezFXF5tuWj4DaHWABgQyYOL8U6Bd6PQDTXAdRs2J9fzi5ZHWOSmgxqVXMdtTI
         8HpHyLmdKGuXdsDJ415xEIk+4lyMQFoMIRDqK1e/kBk19IQUkIaMwr3QrAXbMfc2tzl2
         J57RQidP0M42bBhpWldxFp2b408KVfn3kjhm3qX9LsIcb7ddHrx+2I8Xi3c+6hsqJg9s
         F7Zg==
X-Forwarded-Encrypted: i=1; AFNElJ9/fGmeEG9iqCgFW8eHfnFIjWzWclNrcq92Q2AY4KLmiKd3mAuVc7/mAEnog/tmDyWKUP3bDy0orA==@kvack.org
X-Gm-Message-State: AOJu0Yw80XJjGvmdR1OVsga+GcS+Z+maMZlsheyVDlx27vlFJaUGSZSf
	DyHesizp7T52l6ZqhiF86B42m7w8bjHTE6QiFQdMf3dz6t63WwicvIAFUL03cLEAZpU=
X-Gm-Gg: AeBDiesPZxrN6tU7c+GXi9hDmYhVppZzvr8LYlHoDmaOL9DoRRBUDTbU7Mz+4UFBe1+
	wvtUtp81FfXqeCqnRVwtA4Zw1Bo+oLff+GnboqRPJCb5fjR2o9Qr1R2rjruMrm1T2UZ6mRcYupv
	RL9MqrbnOZ0nmD/VYam3krNsS1sZHPkLo/k72B7mxKAwfKkNRkr/L1NhNsJncMWFKTzPxVU/LZf
	hiee4jxd4gWh3fTvPLNH4zK01+6dlNooBdJDpwspubvwDhnJtU/BOIqMQeanFaJqrvcT+SPTL4+
	apuMvdfQpnMKkqMtX8oq00TKfUoSlwmjeVj5lf/a2YF/ZoGi8lTOO91kCDR6FOx1iIJ4weog2Ho
	pg3Of4JV3KuuNa43GvH17cYyxPzSH/EHFP/7iY0/V0HAM/qGC39mNBqoeG+7oFua882/KiaK7s8
	svJjgdfKLsi2kdlupG2vR/5/IN0rKq+3QQ/IvvSNsO9rmC16qGGUFaj1qN+zO4CN1iDPCG1sQ=
X-Received: by 2002:a05:6214:41a0:b0:89c:c2e7:97ad with SMTP id 6a1803df08f44-8b028160e4cmr75574666d6.43.1776458042456;
        Fri, 17 Apr 2026 13:34:02 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aea639fsm17884176d6.45.2026.04.17.13.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 13:34:02 -0700 (PDT)
Date: Fri, 17 Apr 2026 20:34:00 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org
Subject: Re: [PATCH v2] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <3rtwn7lkj5icexyammer5limslchbkm4xdgynp5llbt3wwybnp@ikjv5si2xodg>
References: <20260417094426.1556849-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417094426.1556849-1-luca.boccassi@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A789120006
X-Stat-Signature: qitrouq4qnwp6j79yoftjsymi73ntagw
X-Rspam-User: 
X-HE-Tag: 1776458043-782542
X-HE-Meta: U2FsdGVkX1+VkwvyDOh3MdFU5xC0Rob9Z2lk4mIAqQVuTKQAWPozRhiGQT2mIY866Rwl+gjqM344jblj+D8KXVmVL9xEqNyhsZlXEwi8dH5MF/0nEX0kW2RazbEYodJPF0TNSBwvipVz61fSCycL/2m8NO2/3qshlF9byM/A7u8B7shDTW5V7daBfUUHSV3hyTdxBpnYD2wVqpfkWJrbGuRQpE4LQEEYAL3D8Urw9psusvkyven0pTFrUlSzl+1tQw1nMZSBiNWHXtyLsxlKY7F7vXgdnRJx522rt9H+FT92NUgBDq405AL9Tdb+Ig8pZRQRmAfVaIfrc0JbRCaVTYIbLyDgUSbH5txZquTcx0FNzNY0xrqAcyjsUoSnWyL1RghOXNufqqycB5YzZ6ahXUkFSZIkOk+XU4tHgRbEe17dMNzAl3SCCDIzJvcD6yp/La/uSWyx/f2PGbl4DmIu5mftekmTrnQ0enOwR/IX8dHuBx+AdSfc63OMdAIWB6l6cEnDaRyoBHzpLtU9RiytPeA02NzFPmr+WOx6KY/OBAsb8BQpPz1r/TpjHRxVn6jh86OHa3luoJKI0MLgTZeFzBhGF+nBUnYLc2/ZGt9w+0Rhu+0lso2YFxmVZ3bbnZ6v1GfW2WOd0e1cXQXlOWwiQyXepnpluCisDOMoqyfBf3vFdWzMfrAVIrU0Oj2Y9aZC08wuWg2aZBoPmHFqa8Hy5YMaFC2yboL1CSWMWwn2lCNPfhFGyIuenCgx8WuJOmIjLgMNHinUvud/pK+z0m8ER5pUG6slWFyZ6rzsO5jI4NwId9rpX7ke5R2+B9d49bVFYR9gWq0vFllrGVP50N3fJ6cli8pGSlrQnRqEIRBhcLtE/RLMz0P9EChxWF4NG3AlqA0qpEiAterxlvwaMWWNR5N83DF4oN/QBD7dNdctCKYPFpCxjyxJmNVZ+l8UbgGIa+EuApnhIScIzP8NLrd
 /JZ9m1nY
 AGPhuyr5cDNpIzTUPkAoAshbEFWKD54y7+qBm455sio16CSJnkNRcngwFLRY+fJmAOSSuvUOJtvXhYXttFirUa6s2bkysjnZ0T3BUOOJw1Mxxz5yjn0y3idXR/hrBTFwojGuNvgDrtwXjlpVnQM/Pf7edm1b9Y5Iv580gHOP1OjLNKxNVVVnyuGGbBM6ktw/pkLau7cT1kgZ97/rijN0dgwSkSdB823ficHvKJKK0YWbBKbPMiYE4D9AOSRSr640fH749RN0YCFtTTiy8ZjfRVX0pLei1fTVSjaju9JCU3is20nYoX1pIh1YKwM/1SrVuHIHO/S5mLMzKfm97L1RWcEtOEhqiDBuJ/HfHLiZdFxtHmX7S7pT87x5ojGrKIuKDB4ovEyhVCNyTcU1OzorTP4U6n8QuC5orIhbr8Fkpte+hbSRMi6prsbz5aJRCrb5qr05YgnwQJt5vL8VJQuOP9MQH8iL5k3EBh0iU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 10:44, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> In userspace when managing LUO sessions we want to be able to identify
> a FD as a LUO session, in order to be able to do the special handling
> that they require in order to function as intended on kexec.
> 
> Currently this requires scraping procfs and doing string matching on
> the prefix of the dname, which is not an ideal interface.
> 
> Add a singleton inode type with a magic value, so that we can
> programmatically identify a fd as a LUO session via fstat().

Hi Luca,

The patch looks good to me, but please add a self-test to 
selftests/liveupdate/liveupdate.c to verify that the fstat interface works 
as expected.

Pasha

