Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7544FD73E80
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 18:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969246B0088; Thu, 29 Jan 2026 13:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920816B0089; Thu, 29 Jan 2026 13:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8227F6B008A; Thu, 29 Jan 2026 13:31:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72DED6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:31:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28FB7B661A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:31:20 +0000 (UTC)
X-FDA: 84385843920.27.13A4370
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C776C0010
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:31:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=fYqWIkdV;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769711478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaMEmesNW/2aeijf2CTvDdAzAco5YKTscfYAQiEGCu4=;
	b=LVuMFQ2Ty5K3H3TAZobubyGeDuIvi2PmUyAdqhiLYZqiWM7PkkayWcpZDRWxXbgIYqkIsq
	K/ugVTnPpI7kFUfEbnalnWmcgfBLwNxqlmdCWdeDEecpbQb5kxeQqoTTEbwkJ4XjtbN4/s
	cHP+DEg0DWzAh7eXhU7ekEDap9vuR0Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=fYqWIkdV;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769711478; a=rsa-sha256;
	cv=pass;
	b=E22u/3yswnn7pJKpps/BnqN3hAmGm/tLVaF+4jYFPzwwj2zYecKMgNPuVfNi481NAMQn0T
	cVLMjJ2LPS+xJTUWrFBYSqa9/kmmuY4Hgio/UPqn+37JPFxHzo3TEv5cxBA2mDqbko+62l
	zR6HKUbTNk5wsGLjk8wMK849Gpylaq4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f2676bb21so10918235ad.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:31:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769711477; cv=none;
        d=google.com; s=arc-20240605;
        b=AjdQ3zK3mMrNmrW+NWrCYbbeOnW6vb9We3cA8nuEyXkBJ6UJQSG44uVaLkGW+HCZsB
         xM56bYgcJGAo8jwyar7u4bmCGwy/HSfqzBK2TCMY3vGNBI3R/9G5Tz+WiRCoaZzKc00g
         NgCuMxlTYxeIoBYK6kpyXuZP5oPU+i+ptvh7qwWOvxv5Ik/JIyXYZhNC6ZZKceFtPmKS
         1R4PLOMYgn1gZSjOUHdGi7FJK+CNfxj2WFltw5wUBOchffFsRgp/5woh9WXEZRflzBuW
         p35qRhJcXSq1k7VG+a4ebepMeIQP+rWWmqkyyr2bUoACtEpgaAgLIVzxSfZCGHGWfTmO
         gSiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gaMEmesNW/2aeijf2CTvDdAzAco5YKTscfYAQiEGCu4=;
        fh=zsDx9NwI8SJ5O2vGMXwyFWJCaLD7M6aXKfDczLuXWrQ=;
        b=jyHCcQdkhMZU/HIBO+vFGtYfbp1scet0hLfd/4wjyV6CYHd8a0KQfMuyU3Zw8EfGCh
         FIvnP7F0wgHzuK+Z69Eedvuo09TDFcThJNtX/DBLRIXr6/3DCh9NDe615w8IuobkLrEF
         GjcCz5lPZ2xHjhIKUrG1pLqf64k+zidvacePi/Cn2GOGscNeWb15lzLDMbnspCFweWz1
         zhLBMeehA1MbPNnjiiAhOHipZzaSSyXVAxF1yAQC7YuJG3cwmT14uY60ST7k7sI40/JU
         wOSsn6XMnXiwhRi+ZP7WwF3ImF+eoFFgN0IlTfm1KFm5TIDOhqos0TTwymZq2lOsDAQJ
         6icw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1769711477; x=1770316277; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaMEmesNW/2aeijf2CTvDdAzAco5YKTscfYAQiEGCu4=;
        b=fYqWIkdVPLDiI3rNvMFdLDmRooFKq0td/YefOFebmBRxEFIJYA5WIc+eB+pFVjzywz
         hVCzAvVRH2+Jeg2WBhSeHyhbbqi7TZwQaRLa8rOS0zbwQiZFU6EZ6Vl4zBKydG5UygWE
         0YM9UFvGBk3TKAOCEzb1yALngvxGqNW1rZyDm6i7YdGBNEgtlaaDJPN3mCWPrdJnXpqA
         G74Dle55gM0yOsMw8AHlUn+qSYE5legRvu7J28dETsjDX8cdkfxdZOaKnQfuIMRH12Me
         um7wEguG3j0tmFDUu5EP8/RpxDooBGwG6uwHLYuzJk/9JwPcQrcQCxLHB17+/WYGgVMq
         D+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769711477; x=1770316277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gaMEmesNW/2aeijf2CTvDdAzAco5YKTscfYAQiEGCu4=;
        b=uKZNJxNryjiojhlfENMGtzu7yq39PsXXdRdFp8KXD9wnusj/uBZw6zhPXqK+0j8GOH
         HF4/A0QtlfoFT9hTM2rB2CR6vX+XiPdMSMWk6TwuXTFswjCk5tr/8TmXtw0kaxApi2t7
         +5yRTqRmGbty38H71PsYcMLb45/UV93HYvdyBqkSKdlHcUtK5uC/nox/4wOyNqSX0qLl
         NERxn/Hof/UiQeWaxamMjdKW83Wc20KwtgNzXaV5Oe5IdptG7nYFPf4Z0AfIj1N/urbB
         r4tKjq5ePIFaS6Aj8EwYcL0OR/rKWDlQEChNpMlf/+q5+3RaLp6Q4LsApkeI8F+qs3kR
         1nMw==
X-Forwarded-Encrypted: i=1; AJvYcCXx6+DxfC97icvGfD0gdzWAQzyF8/wxBg9zmZqd4zzTXac0HeXRQdhmgVVaY1441123Xu5cRvY4xA==@kvack.org
X-Gm-Message-State: AOJu0YylNm1Y/Lgj8uY0NzhCoI+lf2+D8zpBr8BEpLgRABtLIlZPOiBK
	kzraPzdjrj61ezZwFyalmHxXeT+PZVd/LhpTBMtcQ1GF9S82h3Aiv+tx/VkD7CwSJA3CY3ENzxQ
	ndUOrE33j+ze/eRcbpBwORGXItTAp4QCxid+1pCGO
X-Gm-Gg: AZuq6aKWCUdCBNIE0yBaEMx2XxslbS7nrjnloxH8sIQtQQymtPRQMH7t42U1JaVN31E
	UIlyjqAYjmPY0T387gwk/1HNxvgLa5TprdaRpD/wE/B/rR5f93AtSe84Le/qG3I8/TH7lwUVLyk
	BSOAcpBI9Jt27CO3lOiP0OG0S4EboSV8IUGw6AhdvH6pTdGQd9cePXL1FV9Q1tJTMbpkgqwZU1h
	cWm8uWLCVbo9dGH9hT3l6rLBA/q4ltvMEhTQOYP7vCb/iVgxAAP1M5XpxW2Nevn7KB4RPQ=
X-Received: by 2002:a17:903:f8d:b0:2a3:1b33:ae11 with SMTP id
 d9443c01a7336-2a8d9949210mr973325ad.53.1769711476784; Thu, 29 Jan 2026
 10:31:16 -0800 (PST)
MIME-Version: 1.0
References: <20251017202456.484010-36-paul@paul-moore.com> <20251017204815.505363-12-paul@paul-moore.com>
 <20251017204815.505363-21-paul@paul-moore.com> <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
 <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local> <74286aca-a565-489f-ad2c-886c650ea2bc@suse.cz>
 <01cb28cb-56b7-4862-bf27-07e4bf17115e@lucifer.local>
In-Reply-To: <01cb28cb-56b7-4862-bf27-07e4bf17115e@lucifer.local>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 29 Jan 2026 13:31:05 -0500
X-Gm-Features: AZwV_Qj91bihFusy7ufZpFTlJZmfomzjnqMHFZc12ATcxs7ntbmfJHUq6C4Bs2Q
Message-ID: <CAHC9VhS_y2gy2nAK7C-OpchME0pzS34-QN2bY9t5SRBXArz8Xw@mail.gmail.com>
Subject: Re: [PATCH v5 10/11] lsm: consolidate all of the LSM framework initcalls
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	john.johansen@canonical.com, zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	wufan@kernel.org, mic@digikod.net, gnoack@google.com, kees@kernel.org, 
	mortonm@chromium.org, casey@schaufler-ca.com, 
	penguin-kernel@i-love.sakura.ne.jp, nicolas.bouchinet@oss.cyber.gouv.fr, 
	xiujianfeng@huawei.com, linux-mm <linux-mm@kvack.org>, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C776C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: nfhs8x14gucmrisentbfnfj419fwpb47
X-HE-Tag: 1769711477-736675
X-HE-Meta: U2FsdGVkX1/RrYItfhd3/zce8cIyr7gbQsQAxe1Mi3TJEH0qDkLb0zYYSkCCS2J4pzc3dvYRp0/qgler3UJERGjfSz3yEwa9iwqNedfFEBOUBy5p9T53mvpa3prWYvr70N+8+qXRp0LKdKF4FohdxVAyyu6Q6/0UAzvtymZCrVyS2LyUP4pe+zhJxSQNKnneSWQqmaY6thyUK43rEejHT6T4JfQLB7RFDhbkPtaUImRaHqJSQVAFZ/LlMZ6DregTKN9Z3NrJXpvmCVEMuxC/40beopy8gVzBWe2OJGDZhCV+6nqJq/PBgW3RQAx8v+H67a0nLs+LbwwEF/r2b19kwQnIj+3BXw0IHlnO0cJgh+UXFiBGSlRBLGEGO0BD/vmmpKPnVVYDWfWw+Phl1icSl7ZJsjeBSrQO0NlUhO+qO/M8y/QyE46AXwHwSinExqU3uR3C5+uCu1xHIV/gmZvuDIi9k4iNQfUdZ3XI3pAi3IGqkIsNUElyPuS30GaBfQxy01LE/N3v37Ebsco3thUlyZg04ZSKmEFHknfd6JizetuTHbmkdn0wE0nfBctqIBkGhwQnqHXlYaTjWV5Hic21FOGQdQ7QC6ca8onci4+/ffUFmdGuvfebNH81NXRqUs/kYecCL52AR/ipMUbbM3fC2iCsMK3t1wldrqZc5e4e/7SB0e8fEoEZdnjnMy8bJMtc4ioTiTqYUNXJRHIpO+fZngmtidWlrrWhdr1wxxLIPIV5l6wtjWH6lQrAHeU+UeBU45fBbCt4DeCVSjk6kN0Tjj+KPXsG0lBSv7cdMRaQFFUH+s3qBJ+yYm1BIuBIXSKXy5GHBqcdXonqr4gijbftURRvcyOfc2Mbt1g80wE1J8YnqZBMCZ8kGKFzgdlRm7K+FLvTBZlINHspYDtHNw26MoHU+ah2Tdi8Hry6BsE1FtONI4Jx5D14XOddQsGfQxXLo7yxURLWbhLiQmKk24Q
 LD9+fbAL
 58V5a91dNyk6coWNvOeFcL37d3SYlI9na0ZHPvf/gBCJNaaRJDknbtLK+1AgJGJy2E26vgUe9iyWn3ZVx3Pdy+cWc/78MlgxdO2WphnGdInM8IN9UXBvDaQkVhBRsUmKeSvTM4/+xT51vz3h0LMI9rVl7j3rPdA3rvsd9qYxPp9kf+1pd4U0lv92HuAXcOiW3AJ2eGE5MnQ97wz7KIwvqT30A/h/6jCf2Zf3Vtfu45w3Pnr3yvhOSKpDC681TWeJW14FvTvZiGd4/m3y8Vq6g6kFPWjhmuFUH1kv5jFAV7XuXrp0qG45tmaPlNPf3uBpNi5fV3IVOqPEU6BCO2i5p+3Z+V5bd3wD3n6rdYKa12p5RxIiP/aFfN8wFulzpV0byAha+92rMohqn7kSObO3gZ66xKJUTfy2fHNV2W+JAaMvcGu6PjR5uv2F8J+a4cH0hdYG3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 12:11=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jan 29, 2026 at 06:02:00PM +0100, Vlastimil Babka wrote:
> > Agreed, the mmap_min_addr should stay visible and applied unconditional=
ly.
> > AFAICS the only relation to SECURITY/LSM is whether CONFIG_LSM_MMAP_MIN=
_ADDR
> > is used as an additional lower limit to both CONFIG_DEFAULT_MMAP_MIN_AD=
DR
> > and the sysctl-written value?
>
> Thanks, yeah we should probably actually move the non-LSM-relevant stuff
> out to mm to be honest.

Yes, definitely.  Send the LSM and VM lists some patches after the
upcoming merge window closes and I'll make sure they are merged once
fully ACK'd.

> But that's future work, for an -rc8 hotfix ...

Expect a patch later today.

--=20
paul-moore.com

