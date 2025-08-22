Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E47FCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 14:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CA2280020; Fri, 22 Aug 2025 10:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63838E009D; Fri, 22 Aug 2025 10:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A43280020; Fri, 22 Aug 2025 10:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833F58E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:12:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 010F5160208
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:12:04 +0000 (UTC)
X-FDA: 83804582610.01.8D81A0C
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BFEF2000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:12:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A0jNfxg1;
	spf=pass (imf03.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755871923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUrkI8gRxT8al9H8bcipd0cfLDrY2l84rj0Cw0HvR90=;
	b=yzlVOsCsWh1FCscAIM/WXVMtI2PbpRid14DTAAjPlTM7RVqW/+uRMgUf2ZJzqytBwuaweH
	jdj40Zbw2io2voPnVjFyOEfkZdFXUmscHXVAS8uTivlW2dj67gWZMb0D4WPLXpO8/ily5W
	2R6Xixksp65smAdI1kOSRyYn7xX9KX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755871923; a=rsa-sha256;
	cv=none;
	b=bFG/ACkrOcbFgHngXUPMlO2OxFfMbkoNJHYNq3BzEZJIU9liODDoqs7rdcz+GSqn4ewJ3K
	Nv1TO2ZSiPAQXoRFlfQKfbB7f66Uhwtb2HOzsfxzxuOFOYdbYwHbVM2yI7SjZ8n4B8CpJ4
	7z+nROD1Tl6gAa8MO8t51L/VgM5J0GQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A0jNfxg1;
	spf=pass (imf03.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9e411f79dso87058f8f.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755871921; x=1756476721; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUrkI8gRxT8al9H8bcipd0cfLDrY2l84rj0Cw0HvR90=;
        b=A0jNfxg1hFVd6FlWQ+RgqrJU1TS34BIyYjoX8I/tmHK8hF5jHJJz7kkpiA4lap8O06
         jJX5scxhbvVSG39XGLzzlxm/R6m0WQBjOT1ZOzogpf/EGEoU2M/Dkf1nP2/34sBrfgUi
         P4PrSu1B1kfCHqwEhN7+FSyohXpUbO+T8km0FZaLl/xSEaCwbd835LvKUbcyy8bZ2o07
         pgwcYw5tAtqBaqoFZvdWKm2Yt0BA0B90pJG4lIYdXWSqmVe3IB5eHy2DgmDm4Y2pUJAD
         +NaNBAp4JMyOad18cHwnxH+38SbNXaUeeX3fg1dN/Oa4Vw0dPbxy5+9TrSm6fQPk4DuJ
         o7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755871921; x=1756476721;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUrkI8gRxT8al9H8bcipd0cfLDrY2l84rj0Cw0HvR90=;
        b=qSyA7T811ayAq/qtTbO0qhx9jTd3H5Vx4Rw7FSV3goHba0OZSWfVEsUcdTiYMlxOLW
         mLvc8DbNw71oumR7BQeEXR2Q5iUyuDIm8EuqggBo5zexvVGOiaGGK/v1Gc6LvJA5iL3D
         GdOyAjOjB0zIxFrGDppWJgLTjrfU+jQZPwjz00K7GsOXpEzlACMv3PeE+oR6g98So4c8
         SlVzJQJVQPjqRfe8gG77SnhbiIYULb3x/FrXe89c/DzzGqSvyoMLZEbvvCRSaxYsDr9E
         Vx2QLQcK09bXsA8m927HBk5IUsJ8D3qOKTK8vuzDg77yBXQjLdlmwNIsIn01420BP0tX
         HjqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTbb17NIcONBBCfAZhdyKdZ4adMkmtxvr0zjhZ+uwaxY1nkTUpJHYqcX9JZNndO1dO9Ayv53d4Rw==@kvack.org
X-Gm-Message-State: AOJu0YyhUMLRX/RvOMdgneiC6T+NFzbE5NPL3H7Pk2G0GChtmUym7lDk
	bhC26CNAbDAik5WQeyOnNq08o83J85f1Eykm1v1hgRNwIru1hASZ57oA
X-Gm-Gg: ASbGncu8BVYtuOYRDoD9kR2LU7xeOVImPldJjmHthNayo3H2Pf3J8kZy/Xehb9toCFt
	c+e3I5mKZkdAdUnq/rD7PLEKJ90DGB6HQ1lDedDpMLoYrX+Fjrs+Ub4o+yqPTYDj+1MmciY+CpR
	rPakpcDe0AJr9rVQzW5IeRnP4ZRfJ67PDYl+sdzrb1EItDGI2y0q8zOHTKALDYjeXesBweKlEo2
	G+PMh3MtOzVCT6Kxgu6oWbefBmn/ALXJ9gOGgKPNlyw+TCZSwuYLbBNEFPslwyGUP9qq0QUNPEp
	I1MJ6FgH3ADhP30kQlyUzdiCqUjgzNgxnyYBCw6Tp/mmshRKLhAXFIBmq8UBquZQOOBub5Gfg8/
	Qvj2iI3zY6Gpv7w8H5teyAhrkPOpgOmG69oUWmpKd/rKNd0hnBwHUsXeIhPJUf/MTF/WZSecYTR
	hN9oDl2ayB
X-Google-Smtp-Source: AGHT+IFjwShx3D0jJMvSWdaLG4T39JgpaQyzemTxwtJre4OZUc8C3M5BPxw9JQYLkgJW8PLQe/esRQ==
X-Received: by 2002:a05:6000:25c3:b0:3c5:7050:e2af with SMTP id ffacd0b85a97d-3c5dcdfc35fmr1024231f8f.9.1755871921342;
        Fri, 22 Aug 2025 07:12:01 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c6c737b303sm576035f8f.47.2025.08.22.07.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 07:12:00 -0700 (PDT)
Message-ID: <98191ca5-9581-44fd-b9b1-6f0b932f141e@gmail.com>
Date: Fri, 22 Aug 2025 18:11:58 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, andrealmeid@igalia.com, brauner@kernel.org,
 christophe.leroy@csgroup.eu, daniel@iogearbox.net,
 dave.hansen@linux.intel.com, dave@stgolabs.net,
 david.laight.linux@gmail.com, dvhart@infradead.org, jack@suse.cz,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mingo@redhat.com,
 mpe@ellerman.id.au, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, viro@zeniv.linux.org.uk
References: <CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] uaccess: Add speculation barrier to
 copy_from_user_iter()
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BFEF2000D
X-Stat-Signature: sjund11g3dckyxjsxp1xd6k74cn418bm
X-Rspam-User: 
X-HE-Tag: 1755871922-591510
X-HE-Meta: U2FsdGVkX19EddXrg2obhneN9wqnDeiDZ1a4VJadr78OJBCxecdT1McGwe9+l+xSBtTJkcDF9WiUpCjfVtuLUEnGAw6uVoK/qQUpSXVvSOoYJ8AwAmenRGxURSmOwMgZrs6lb8+YQiItQ6AYrMMzDlw7nRODUIohvyXBYVNJ9G5uNtUhnS5FbvAtNM624haAGYJlH/tujniex23h8RAO/E3ccjihLl/oSJftrPmw2rc5a1UMeYLjx8iwZADKyzbhPDJAN33LnuBp5/gTCWf8ilL/MpDBa0y6DfcbP0Sx+X0LQMjy1cSXRvuhUHD4LXHzRtX2o5ZtR9PFeoMBca/FhgK3630fE208W8Ajm4I5mgyr1OKXj8JkgeIqxYCDlDbcBSURe+k5giUDyJKrHrlFag7LqOtfeVZ4i0nxeUzFkdtBMqR2AlPq9L/E0tkLJSBD4PzLgU3mzcmn+4bQ6TkIqsDs4F4MFcLY3gupG9T3jxCnTWCHInl5prnS+VSczbjF9gILY21iRuyqUeCBbqDir/7i0aJ17ZEyskN3/wrBGFxpZNiGQSFBD+W1yvwqypofTv5o1azXjROB/mH+eh/c8Wkbb+FAMIX4SKdjVnycuKLFNX/aI3mYs+H7IVSTiUKh0WQf7Ky7/ZGb7JQLSujalrLFD6pOI8VXNduSHNAmx6U4k1chOoCBl3QccCydG3Tk2bup610snY993hekYpp0Qn/DsrjSx0SvvqGbaKomhGHjWY4IZ2jn/ZB1B1XmOELbtI43gR164Xj5GryVNA3P2h2HSiiCXGAMxtLvaXCD5fGNEiDsFURoQmaJZw4oLQCYgf+Zw+STtB9O4rzAsx1nCyInf8BblH1uhT0USCygA29rHJFwtA86iCh+Zt8j8xmicxpEFuTALV0YWACxpHHwMR6DHjFA8r8dPd4zCqRzDXAVV7x556YTBgaEdWgjncZF57kty+8dqts+Vz4ArDm
 /G1bmrlF
 S/Cew8uMb24/OVGXQNYLuKp4BmGTn7+xpdl4oewKOopPwcJW2ngYjNYhs+hvDixKUoTc4pzSNiDT//HULnzaJDEGxyzvom5d/X5KJw5GY3cbWGvRxLAGuYB95YS55wIES6New+Xw/nkggaTYESarr7lVSSjiAULhkm5PcQde54tHISis=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

so we can use speculation barrier? and fix the problem locally


On 8/22/2025 5:52 PM, Linus Torvalds wrote:
> On Fri, 22 Aug 2025 at 05:58, Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>> > The results of "access_ok()" can be mis-speculated. The result is 
> that > you can end speculatively: > > if (access_ok(from, size)) > // 
> Right here
> I actually think that we should probably just make access_ok() itself do this.
> 
> We don't have *that* many users since we have been de-emphasizing the
> "check ahead of time" model, and any that are performance-critical can
> these days be turned into masked addresses.
> 
> As it is, now we're in the situation that careful places - like
> _inline_copy_from_user(), and with your patch  copy_from_user_iter() -
> do maybe wethis by hand and are ugly as a result, and lazy and
> probably incorrect places don't do it at all.
> 
> That said, I don't object to this patch and maybe we should do that
> access_ok() change later and independently of any powerpc work.
> 
>                   Linus
> 



