Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C7A606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IuTu21EK
Received: by kanga.kvack.org (Postfix)
	id 97B116B05B4; Tue,  3 Nov 2026 16:36:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952636B05B5; Tue,  3 Nov 2026 16:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868236B05B6; Tue,  3 Nov 2026 16:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 601066B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:36:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9671160560
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:17 +0000 (UTC)
X-FDA: 85395116394.19.701C0E6
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F10F100002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IuTu21EK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793741776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Zhw2wy6QkBybAwKKqO3MK9GDD5LduUNu9qTjP9oonY=;
	b=zHeHn7UlCzRz4JVpuBM/MCYXaIh1qIMtJoLRKjYJ2sKFchy5XaoOm8J1+O2HmLjZampBQ8
	ve2dWj9Vvd4y/pGTZN/p5469lmK7XN/XBY5PUTt9VynJw+cmxjxZ5xe5wuDN8RzEWSWPQA
	bsiJUuTvtwv4jR0ycNCTvNMzGVgBcas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793741776;
	b=ywqA3/DZr3LtSaHhIBLmDd1W8M06KPTqyLKzP6TRZtcyAZUvWTZH3GISwFMM3k78AXaQDY
	jI/Qu4MJPEKFaa2mfjeo+iIfy8XWFBqDvgXstEqwMza8I3Wugo8MR3pUGKArWTm4KlEs8i
	asMaokyMRJOTHlua5GbalVw5q6fD7fA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IuTu21EK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so170105e9.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793741775; x=1794346575; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Zhw2wy6QkBybAwKKqO3MK9GDD5LduUNu9qTjP9oonY=;
        b=IuTu21EKNHWJEloHzGxIa/BrL+2XbKS9sCvUmq7JpNnEEVlayentZaSIlUYEQHbiki
         cNgLKQT4gwFZDl3YIfVxUwugjEXmmueA/vTkUwCyN1Snb30egb5zxyeQ0izekkGCyZxg
         WKVILiflNuAUWG5Zgd9LMQwncXu4/Y4dssCvH8CW7ND5BQvJ8eypjzcVTmqDKV8Ax5qH
         A7EeK5S+hS3Yxov79zgp+AXQSknSZmeJwGnBVfPWFIjtrIpCbQ8lTK6JugietXVf3G3r
         3nZyHygEK19YF+TYlLEPChToEpNF9v4XGk55NgnYoG091MP1uRcGYp7f54ZfLRdUME1O
         eKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793741775; x=1794346575;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Zhw2wy6QkBybAwKKqO3MK9GDD5LduUNu9qTjP9oonY=;
        b=Pf3gB+XHleFtctp5o4yb6nNK/AeJs1QD16l5LELDOacJHFV+/I/2Mwb79IbeJY6Xkl
         P+Z/81OKWA27S5BN5HY5503XKUobQOgVVFvqU1y0uLqrPansu3kRg/wFUpdhJxdJCCKA
         /ggCW96CagM3dER5/u0R4c4ypn56Jr21ix3wj3OB8ET8CAeapf9MN/N+6doboI6pRkSn
         G0loowjHn1V0TUq1xNCKgo8zHDG6lFFrLX7TlmsGdfG85uI6Gv0DAWUXe+2GA6mC5HIN
         FGW/465i7zuBDGtpBM37mOtuqHYZeoUiRzzruMPwYbqFpw2b0cekkO3f7QRGuXBsleKq
         dq0A==
X-Forwarded-Encrypted: i=1; AKwUvBzvA5c6fY2QZE7bI6fiDwVq+XkAxV0eg6oDf4n03x4rSEI3LDqtURHuVUQmXMv8+X5iuWdB4H23hA==@kvack.org
X-Gm-Message-State: APuU4Z/TaYN7IGrn1+zJBtlUGYIU0vrSZkOkbwkTXXf3iOfcbJUq1im6
	JJPHcw/gsqoAeI0OMwQEAYbVXlYRkKwFPpZ0qk3V6K8sbgDrOtiD+T2CiCFQyRy3
X-Gm-Gg: AYBFou1/W7QV5/ti9O7iJornFAwwGdStTn/JhUf75aE70yc2G0uppQWxjMaZT1PaGEp
	Hrp14sSMI2u/dW+alck8AV4mPSPnyqGuVKUi4FQQb3MFnBZgixOWF1xih/F3G5YfLpilhWzdnkG
	KntSB+Zu1dLryjtFkzRMaCpOXERpLnDF0f2B5yqGVkEyku1t/j0Pyzrgk3nSowDpL27+SBaqeJy
	liRJBjCtPB4iL8fFsRNEgwYgtbPhCCxDcs1A2b2N8WD5FmL7reN7zUOzS3kF9B1yArCg+rvFHa+
	OLFWI1cPJKsT0pKoISgiMUK/Rc6sbEEcINdNK0oQrlapmWEXJ+xP/F/Tds9Vv+0ePOvsvTpP4sv
	kv0kUhapgXrY9wIyIf6j/I0zdT3yOIkW98PUMiqWkjTYT43di8tRaMmXwi244eb9euoiEdRduyP
	lcCWUav4BY1WOW8xfbiEQqxh/f0dzonXd41gjwecpo2M88j0zIulb4fIvPuCJltstIc/cXYhd94
	YJxPBMZN393s8AeoTzXdhzzM3cQIVZzlX4arDSHuyhttzouUv9rQbsvYTUpcHXXK6MPQMWzvDbd
	9XHcNe7wtlz6EpGGiqTY071ealEGIDYwN+yT
X-Received: by 2002:a05:600c:c16d:b0:4a1:e00b:a0ea with SMTP id 5b1f17b1804b1-4ac150b204fmr317995765e9.1.1793741774609;
        Tue, 03 Nov 2026 13:36:14 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fec9cd43bsm184291f8f.14.2026.11.03.13.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:36:14 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Tue, 3 Nov 2026 22:36:12 +0100
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/8] bpf: Add user memory kfuncs
Message-ID: <aupTzCetiTqmbOab@krava>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-3-jolsa@kernel.org>
 <DMLRWY2OAGS9.3KD9RKTC5MYPX@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMLRWY2OAGS9.3KD9RKTC5MYPX@gmail.com>
X-Stat-Signature: 8ew9dp6jfwd6gorcwjng4os8j78gwket
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F10F100002
X-HE-Tag: 1793741775-216522
X-HE-Meta: U2FsdGVkX19YF7cEOzwqCTqiojQ+Qft7f7ImgCmH2Gz1EsU7EMAJLsFh52D8MjCXh2pJp6Wvz2DNXAwpuSjt1cw+OiRsPMzCof2rs0GfwnZI8/vUGPImODEGD4TnI2eIbKMT6YbsdcywpgBF6GSc8zgrwthnEB16N/bGKRqhQhZib0sT6dp93xZZ/pcKO7emXndlXHSt3jps4OdNcIkkH5E0v32kV/enpLi1XUNKQxGPi6hV+ELoi96SQCV15JcmGMBfX6uuwqWtGIJj3Dx1Zbm+eNzKNhtWtzVAd9qMHVXm3tVvyXluTtyjLbvFUtSH7AtU1zp4e3XOx1Lz8ko3h6ysKWG2/c8dTz2nnpG35mSD/005pQDQLgyrUKTfeUZyPBO8RddIt6jTFLDAIyfAmxMSaZLlQ6Y1vjkzKBb8mvYqgRmYIDxr3hF2hV6COO9AVOE9c87kJiYUAhcOPgCPKCH12kyqY/2MD1gmUhh6584N/54u9kGZscJE6GsJLdcxoZHKHMfGs2NqhkVZ7gFSC/UIhPNA3mzJpu2UQ/ppkbBO6LCTGCcKxN/qAh8gKnREbEHN9XWH5Pb13FOnWoFllIbmqO8YZzLjTU91HVTK73KkzwwpycuF6DDTvcMiBc0t/DYN9K6+7wO13+TQOdSt97rlayN4CAo+gh9+wcLF9wpH+JWTwbAYcAkB9V927k3tPvDuuX1TaBpkgdSE2Vmk/ahwxw4sQG3TM452YXIdzTsYAvFvRPLmswHzjqOF2G9jSWJezRZrj3gZ2xgy6xLcDnk9gCvTyU7fxBoawmKqqRwxy2Y1109Go3TZeKiGpp5UNXaOPBGTHd3QCiflUlwz+tSn1UKb/aC8tYEZkjOBdpXyI9p2CEtOEN/2JQ/uFepN0ruJ7Qu+jPi/x+ctIV0LBbV0KFln0DGok8LfoYn7ivTf5/w/jCXLuLdTog5y0fvpSIiNnM3LCO384qvGJ2C
 DBZaT6vM
 bLNB/vLhXACOnuGQ5iyGNZHe/l5rXQjZvYuyyqdqBGvPZTJ0y0sqmV4hoSOHP3ZXtsAjIMxtnhKqWaceICaNhryvoWlHpU7Kx3hUOV/UvHP26niPmFjAJPmLqQb48VzgmZOvaTaxR6JypWmXZgoNu4IfTU7IMiLt8C2096qK1qViGveumOTcgpXAGTJ9YkzHEdGZpahgMiAFB4LjXSakzuzcZl0Bpjm/1hXfQa/0bVhnNS3EfXTVLUaRciTb+7CZhrTVekXodlVjwDvTpAFj3PBjqv+Ou35ESQqVuH67do9SJSYmcZkQxSrtgBvSCUTQwnwALfcK7vm7isYwQSreTFGdellFOZTai4+U7xNo2CzK9L/szJWhegyjbafzrDk/plP0KoZSONLEZLTK+hhjmKHhJjhSWUCzAwANNBBLsQKrgrJHK88K+T7jRdpIpAzsE940nQOT+fK936eX10/+bZeydnR2gHlV9TrG7mIW4QXUgEo3xOTkDxpQ4YXRT61xuBNkbKH4+HLbBHplfb2gus98zxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:05:46PM +0000, Alexei Starovoitov wrote:
> On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > +#ifdef CONFIG_IA32_EMULATION
> > +static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
> > +{
> > +	struct thread_info *ti = current_thread_info();
> > +	bool compat = test_thread_flag(TIF_ADDR32);
> > +	unsigned long addr;
> > +
> > +	/*
> > +	 * We are not in a syscall, but x86 get_unmapped_area() paths
> > +	 * ignore TIF_ADDR32 and rely on in_32bit_syscall().
> > +	 */
> > +	if (compat)
> > +		ti->status |= TS_COMPAT;
> > +	addr = vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> > +	if (compat)
> > +		ti->status &= ~TS_COMPAT;
> 
> Do you have users with ia32 tasks ?

nope

> Without this code bpf_user_anon_mmap() returns -ENOMEM in an ia32 task.
> Nothing breaks.
> 
> arch_uprobe_get_xol_area() calls it a HACK, and that one is in arch/x86.
> kernel/bpf/helpers.c has no arch #ifdef today. Let's keep it this way.
> 
> Drop it and say in the comment that ia32 tasks are not supported.
> Pls don't add code just because a bot said so.

ok, will drop it

jirka

