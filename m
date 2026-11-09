Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6A1606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P/RtR/LH
Received: by kanga.kvack.org (Postfix)
	id 374256B05B0; Mon,  9 Nov 2026 06:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C7E6B05B4; Mon,  9 Nov 2026 06:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B336B05B5; Mon,  9 Nov 2026 06:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD0DE6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:38:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C9034064D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:38:56 +0000 (UTC)
X-FDA: 85415383872.01.05220F2
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D22840006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:38:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="P/RtR/LH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794224334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqzI2P0ubLVIWtFBMZak1suctx0ODmadmSDnzYGG298=;
	b=hrv1sloMIBd5c18Kuw4I2vB1zXQeLTM36tXSGzp0h4vWDujt4MG4UtGD+OBwaL8e02INzW
	9mNCT/twQp4OH5/AOtr4i4yyoPHvRgg0czEHa+mnKaPwx3qzMuO757yQexE086z1HZDbeH
	GoenwyeT31rCE8n2IUvDazJ+vg1YBgM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="P/RtR/LH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794224334;
	b=3PHcjfWLF6JL7rU2BHvGdY7NDK+6D5SZ1wlu6DVEnX4q0QPc7y893Q8ERhdHNNl9UzOLzA
	+wYdnHIHGyJdfvyvLCvfqsPlFGkIyJv2NfA0075r+EbC3KXlKaSMvOgZDX93CNxKKaSXUW
	7ngIrt3jX8vtjGPQcJWJyqJfXJhI7mo=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1238315a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 03:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794224333; x=1794829133; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WqzI2P0ubLVIWtFBMZak1suctx0ODmadmSDnzYGG298=;
        b=P/RtR/LHF5Rp9lgqJjN1Fqihkf0/2MAtIJI6NIjptgqNj+e9l5IWB/q42+7dpU+5wD
         tkQGLKoDZsgarVCm9gjUyieSeNX8zs2yN9Cp31/Qkw4A+PDJjQauQ8Iw2NeBfDsu+bAV
         6ANJLJMtDvpvqBeywnFdgMTBS3tW42Mj8xq3J95J+gvtIuigyzijKTnUruqli5j9yUKm
         fAoUAxFngxozQ3o3li77GuD9OBboK0WntNKZDOKYMLrQugFB18ZG25D6nlx+tij35SUu
         UYb3Wg7sYx8jwKLXKjH5UDLeX49aXGNhogXGtf8/w220Jq9n3B2fwptl36KaCf2T1+GE
         trlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794224333; x=1794829133;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WqzI2P0ubLVIWtFBMZak1suctx0ODmadmSDnzYGG298=;
        b=2Ox+96LT8k7ooRSJ43bhtdzmKxETupWR5+/2Fy9bZ7LVtGsoeZu5aHGV01AeK/gsgM
         zi6NhcFlZpr54Jx0TAJgVY4d59PzPkWjWJ7m6QDZ3Pme+/mbbmxG0uSD/R7LtDnBlXCo
         mL9GOY6svrYjx6GbK2KrNowCHASmlELNo4XAegXwARR2bX7BHoKzudPoYYzdyk+hdrt8
         qxeH51jXlWgF+j/mY9eCDgegHC66YWNL9DNQyz3mg28RYIAf6tkypTEpk89PTix1rm8f
         EcTUjg0f5B0hebqqUxCY9NcXq6KCAckHGyFGdRH6khsRZwcKPhRzwXm455blIHymVABB
         ScgA==
X-Forwarded-Encrypted: i=1; AL+hErHsJmMYI8bMa/NRHQgOOOj+yvEaxOq+qvZtuWQifViJ3TklanFwuvWqjNhO63riq0ugELcZ4T9UkA==@kvack.org
X-Gm-Message-State: APuU4Z+tFsfFuqVjGfzQzdxrMq0xKAEIMAljye9aPOpMcCKMUsYd/BUv
	GlKINhEKG2RVDCW1nlMdp4NGy8WcY7NelM+9oEZ79VrSLffhv2nc3Gum
X-Gm-Gg: AYBFou3iNOvkrgL+YyCXiwttiOI81fFzts7B08ikiFHCusAOrXRVtEBGHs3uHwEhGSM
	p8N/OUmMOO+2VbNjHQDY/O+pt/mhcgfcsjJ3SaoFQ5d4xCPLGvwpDfmsKjFvWpptvi4vquHGwBl
	dPcQaO9bOhsTqLAS3hdO3y/gaYPhyHWsvwUQt1jWw4pAbxy0FGXqliegKAr+qlFbeEG76vw7ais
	X/SJdAU7ZwQGOatuyCwfxtydBTNM6pRYWPYSsUqrrwjuGO6THOxtANAWAXDlmzcvFbx6JEIicc+
	mpm4k0GyWPg2RaOVkE66Tw7kSX8H3wghOACmXBk6F9U4auNBTT9gV4Edh4b3koNaqWNzFLrdTQW
	Yvvy7/WI1IHEU8JMwY3BNoemtajex9ICXqDFkVOiGzcfDXueVm0A0j1rZyC6JtyYSlhhc+lP5hl
	fB3d9UaJVrRFB6NwFg6ZOtSwUTndZutMFa8af/g/5oyd+axH9RTk8ECKxeqbj3S4t+KhqSEhs/F
	uZINaChcOL/yKW4qwiwQbjPALtTDzw7gHjAqRriN7PXyu6FxOp8KNM3uxrd0fjeegDp
X-Received: by 2002:a05:6402:3604:b0:6b5:9714:dea8 with SMTP id 4fb4d7f45d1cf-6b72249b331mr2626989a12.45.1794224332902;
        Mon, 09 Nov 2026 03:38:52 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ea56f2sm1479837a12.8.2026.11.09.03.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:38:52 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 9 Nov 2026 12:38:49 +0100
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, catalin.marinas@arm.com,
	will@kernel.org, urezki@gmail.com, linux-mm@kvack.org,
	baohua@kernel.org, dev.jain@arm.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org, rppt@kernel.org,
	leo.yan@arm.com, xueyuan.chen21@gmail.com, chleroy@kernel.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	ajd@linux.ibm.com, jiangwen6@xiaomi.com,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-ID: <avGwySHgt3qCmvIG@milan>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
 <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
 <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D22840006
X-Stat-Signature: sheknou3onaezd4z8bdaopqj788spoh9
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794224334-449344
X-HE-Meta: U2FsdGVkX18zOdcffAcvmzN20GhZqUAUHCH1rye7wToNVwJGx08eijcX1C3Ai59EzMv1WZo83VQfhPMbln4np8uHCCstF6DxFER5b6CW71xaXFaduIITjC9/9w29J2EmyNVW1Y8ft5Zmgpua5z4YtfEdDnYTR1kWXjdVsnrlz+rIg6JKHveY0sL9gnxZAgdHPtxrQZQkbgwwpB270UjI/kdCsWP/QlAh6kcs1ewEFCpJ3etzlReA4442ms0vWIwnpGOPrisFAowhKCrQOzRGTGZYBA+zXDbGNabayOxSLFIf9k3xadpQAyiKsvXlrTPAzCUjfnRXjteH43fA4w0nL/N7xtgR02J4EAXR3uC6Olhg7/ANjIBr/CfKFecG2TkuNYvK6fmQXls4T+xuqKIVzklxG6zDt5WyH8klYn7WMPl2FOWUnG/qGmxuCApj889IKYaRqz6pQEIpX9HUneoOk+8lm4joOLG2GhAOzmzCB/dxBNts6uW3U/4GjtQGg/8uEp5CcQ6VHwtNxpC3FjNs0NXQxLrZ1xrwniV5VIn/cuH5etSKAkPdIs5ceP7oy6+sGo6FK6TpnU8yDr0pRL1EN4Zo7qDLpTJXiH2HSiOAyAHQQIbWoTEEmYSj5pk3KrivzdmpHfhJUNx3OnKRAFul0wPvCk0KMNoE8yxZzDF3Q8Lsy9Ossv/tJFyKtZxallvp0GHC4LLyyT0y4CtIriTP+g3A996uCmJrE8ZpICkyf8QPzejPlfa5ZNStYaCQAFn1lOYeaIgi+DFgvb9pbGvaa4LUhB6xVk5aq/t8Vbs8NIbe7crb/G9Jx3bpz6TNZKFpQt6SyaHRZpbwazwEQr6b1/WLyScyuNiK4tOzGWu4/rE81l8xK/IoEOdv+PFLIu7IyfFo2SjVD00fEp31xa1OO/BAr8tcaCBQnlm9sAIHEzFt7715/ckxgZbi0RZdjKtuZoaMUdL+pTkHI2d7M1Z
 NyvLiDjG
 OjOsj3TNVKlC1pyMd22RNLXxwPHfDBi7goWhLG4rwfJ0blFjBcZyWwfsZWfFsBCT8LEyIo+1u6ygSw8GNc1OzqZRS3T/0lsaZQxdKYZfJBIO2iEvp+O5+GsVQ7InI6V/lX1vUFYN54oE54MUUaNABzN5GxfdGmTw6peMT+trX8nZ+lxDhqSmk7XXIUcS2Tj2xEXwaEyqVzdABggx+HUv80eapNJGAXg9n4V4mPgFJLc4P1ZNQ1pjXYP+7b9WxQQXdb175wpZ5vr01Yx7nUgYVSxBJU+KI6kFVgmzzjjmmxwMf5Ge6+WSUODtRaVXQ1nVjNfIpU0B2Gccki2Vox06/LCdCLYR/+hSdXegJzEHTA/uyXbDTRjOLwja9ttc/fspWqk2RqwSbTHA+0yVvhME+iokLvxgQs+QiD6xx96WsffaErwUIlDoNI3EPmD57WkP82ZjuN+3oM9fCX2qq6w9SggqGuAGmo6Qzm1YGIyMnA/jvgsNy/RSSctEQ+pTwfGxRhfmIep/sD8hJCASdxkp2YOK832qHR6A+72TC6iHFadYRvRly/eNJcUOVEe65sTuwNhDwHpJsqpdV4H+PTBMwlk+ZGWI9n7AvP+xU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:07:23PM +0800, Wen Jiang wrote:
> On Mon, 9 Nov 2026 at 15:08, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Sat,  7 Nov 2026 21:49:43 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> >
> > > This patchset accelerates ioremap, vmalloc, and vmap when the memory is
> > > physically fully or partially contiguous.
> >
> > Thanks.  This looks pretty mature and reviewed.  I'll add it to the
> > pipeline for linux-next testing.
> >
> > Sashiko likes it.  I'm working on a different AI review setup which
> > finds different things.  Very slowly.  I'll let you know if anything
> > interesting pops out.
> >
> > Do we have sufficient ARM review?
> >
> 
> Thanks for picking this up.
> 
> On ARM review: Dev reviewed the earlier revision in detail and
> his suggestions are folded in. Leo Yan tested the large vmap() path
> on TRBE/SPE. We'd welcome more ARM review from Ryan, Catalin
> and others.
> 
It took a while but i think it is more or less ready. All patches have
been reviewed in the v12.

--
Uladzislau Rezki

