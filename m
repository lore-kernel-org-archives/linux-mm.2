Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16FDC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465D28E000C; Wed,  6 Aug 2025 12:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DEF8E0003; Wed,  6 Aug 2025 12:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353FC8E000C; Wed,  6 Aug 2025 12:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24A768E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:48:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD08C065A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:48:46 +0000 (UTC)
X-FDA: 83746916652.29.264073B
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id B91B5C0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:48:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPnfFJHP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmPrYTqmetQZf+sYTQVyZTC/l5DEffFetmuMkntNP/s=;
	b=bdZnvQruB1DB9Mi3vbkr7zXhh36cndU1ouLUZmQDMu1fdinOibZh/6+F0VOrx+9xhIYmvV
	Vi5HAN4NOGLdLcyOaXY7Kj6c22e42Ozh2yIw92d77B42x67qV9gmi1fhcR7tHYbKqI7fVj
	yjgwK2IDIsuLxYY29YmX+1Dvn+rAr5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754498924; a=rsa-sha256;
	cv=none;
	b=KBu+BiGgbwOhsu544znP7+N8nn8m8aivAnqIxVGpjKoogayDOiBmhLDDA03hoGE6ATI0ri
	1EozMNs9MRdXiZgDXV2cbqGFyiVj9bH3EH4oa/uO93y3OlLnvsIBvTXGcIqloPXoswX0mC
	uvyClj6blY1JfinVRcVLB1ctqG3Pv94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPnfFJHP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7180bb37846so97257b3.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754498924; x=1755103724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmPrYTqmetQZf+sYTQVyZTC/l5DEffFetmuMkntNP/s=;
        b=cPnfFJHP3E8wcsA2pGJOuBg0p8qJmNeAqU2KQuB/iSGvDtoR1WdYBJQbK7WhRyNscp
         QQa4JVcNv+i+ahnvoQ3zORjst3DwZjTBSZbGUvus+sf4/wIhcBi1G1AlGjxoHluk6oZH
         AyVFB5hCCTqNTdGRex8EuZbuq9y0/IRsrjHh2Vjv5ZwJ8LCN07orTLpK8w1dt9grPuuB
         P8K0ekzphnsJEqz9IxmCziHnjpPgrL0mfryC+BHr55x3ZWhCh+6NyH3xBBRgLsfBTK/v
         p1sl9UztKxhZm06Cubv+O98Fp4woTiQ8H0Nfrds6OuLSZnXkxXoMfykjG42UbFXsIbEU
         xqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754498924; x=1755103724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmPrYTqmetQZf+sYTQVyZTC/l5DEffFetmuMkntNP/s=;
        b=w0ijVcQyxKlE10aQAzHVPSMEgCrQ21osjzR5KAwqxNMN+XeYDdz9Z5WCWSrMF91l3k
         +HgJUUMUhziyxR5HSufpt6s0Eh/un7l2HrGo4bEosxnJHnw3SM/bmU+RtP5ZxHyTGlSu
         TrX8riOLOq09GwQLNltD0SR+mtS3faY/KQvIt83EIZ9vJjlUm+02t3zW8c24HmL61Pv7
         Obvn6ZrBqiNQrb5US6gtQFvqvAueVKN+aOBa0kowvXhhNbONvUHvuUURd5kTwpBvI9SZ
         TvixHIHaeyo+tMfrYBHzbQ+up78HowJxJ5NZ1RL9Hzhqx4XZt4Qfix8QcV008PJ4sg6A
         A21Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjM2o+3e+ad26WFGLKOHKzDEbPcjCPkjRuHeEwGAh7VFNHysniViCjjpD7jyZ40bq3vN4CmwEm1g==@kvack.org
X-Gm-Message-State: AOJu0YyH57vXUO/7l0GhaXj5g4UYg4UwVJUjA1dvY3ivTxbKfwH8vl6A
	C9Sj+BwKN3Sml+ycD2kSOQmbbv8GtfmD3sZRDh8WaHzVlUPDtPJgnZ/m
X-Gm-Gg: ASbGnctMRd3DVSmr5e+yL5Lfl9LJg5aYTx3Z/92DMruVvbXFpokNfN3YjlEu0pfGoO0
	CEY/iidSqAGxdE9dF8bP3YeLQm93zCgHcFF/IgLlv5LTuzTf73NHmlEzYun1bU7jIulxcxWhk7e
	l0OHVxyWhIBlOyETzM0YW6wooiTC5pRA4rCOlg5E9SDYQdQOzdM7thevG5LBMJAMyoUhxQpyIr/
	MZKN207yr2C1uLoqrdoJAQAyBo/VCEw5RMQP+ZMPnNwJvsQnhvcj5+c25R5BRkmILj/BA78LbRn
	neTqoU/Gzk0xtNej3XuaXgUctUS/GYmY/aNG4IKJ6lGUxVmKGWASKuNds9Cbi7PZ+TtNUVQw6XZ
	5SmTx9wTR4HTlDfzGMGsG
X-Google-Smtp-Source: AGHT+IEstsp2gFEGgrxRdxUAUocyEahZ2ZYPH2AcZjPGnW3zAFBwgU5t1obUzLf4lsOZgrRjSOzrgw==
X-Received: by 2002:a05:690c:a87:b0:710:f39f:4d3f with SMTP id 00721157ae682-71bcc68007bmr34294307b3.5.1754498923579;
        Wed, 06 Aug 2025 09:48:43 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a3f9ebfsm40251297b3.30.2025.08.06.09.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 09:48:43 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: akpm@linux-foundation.org,
	peterx@redhat.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] selftests/mm: use __auto_type in swap() macro
Date: Wed,  6 Aug 2025 09:48:40 -0700
Message-ID: <20250806164841.2907972-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B91B5C0005
X-Stat-Signature: 1kar8gowaega7coe7xge5zcob31e6r69
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754498924-570203
X-HE-Meta: U2FsdGVkX197pTHyXGsSf+PWODh06vmAhPgatArxMVPL0AyljOLVVVRMNk2HaO61LAgCA68XPAhf8//ZEnGqnNDGUrkmuj4PnW82hh5/7PNhgt5rRTh7Jg30SEmeCzwYto2NjGTQ+odEhRsGliyuv3Wjn+7U5QCsTx+lDKIrrzziCAoGhrQsbWK+wl7gAPqoZ3xEp3IwHbkYGnsBkghpWSfDRkUip4lM6EIlpo1VI6pP1MLN8tEwX24gdNB5L3DvoQ57+zqlCizAm2Zl9HSaEhsW/qsULucyA/uTjycn907HXhvFgHSATQkK9bB7/JcNR0wa+ozDSzvgpwXqJK7iqe/EbG7vuIfuoHthZTQWI3usc7FvAOrzk2x1urMDdNzEdJ4ofs8unO/+lf9Vo8nr+HnkWW1PULoEM0x4x/zhxkk5RXuup95WmgcVDhA3AmR18ho5vPga3jQ8/56PYNOjovYKGf8tTYjXJQp67k0m8HFq3cxBYuiTPbtstNY3hjECst6yIMBhgJmr70nML54NKWEmt6yZNBbmGVzFFH04WSOTmNwXZWdOYeUM7b/Drezjg+xMD883NVXV3/bQjLrBgnGIF9IgmEXm+Lkmjj3UJLXL5oHKwLrn8kxMp0tQW8W9HBCz434wbgiYImanRmV9FB/MsCpFwMbhxUfO19Pm5FEJ5jEuF2nG0TYGz/Cw0nTGmjNOZ/pMcE/XbBHb4en06+40wzaD+V22cs+x2y5BWfLs7TW8a0GvR3I/OQKy76Sv7SoNjp5zyvsId5MLUlhJxcbVLWBLq0OWmppwxdz5DL2c0bU2pRD53+4jYpO7+su0n6p9CFcqVxQL+4rKHJA75OEiwwYbueNL5tb256Nem0a1TTgiJck/K/ATxY/KzuY+4ZjBZOlx9qxNwJbJFM3hAAPuBxQbUP88Mc12gH8uftLNs0G6qgHulXhdBfmsB3e0fdgmHdCLJQkwNBLrfrz
 sxI64QaJ
 HZotOr6jimWxr1L9SvPPpSW3srALt6EuCH15BolGOsHSgmczlLY15+6U+wNX6K9uttttSt+zdQAD3Qyu+AmYsVE8eomymFjysp0JkWn50VJLz5fF28c20ThWyX39HHHq9H2jICmnJ4EZwBpkE0KqNv1QHUma+GLU1+PMyN4tXos0UMpgohJfWXOh+ZU6JuMv8ASpH+gVeyfbT3BUKS4DsLlVtmKSk/Zn+zlr/S+GL8/uARGw3i/lSy2Ieej6ybSDGuyrZeI7nnOZeS3rNmXFU5x/fxkiUe0NZl8Ed/d1MX6pXnjE8LdupTonLQve9qG8nbTay7rXrCptWJQvF6s+HDNntCYsYL5xiiQuHrRJA9Hrm/IgraHKWfRFvUtg97+7FXBFW8qJ9vUKMk42zHwfi4yxPR6w3aueBRELC0FQ+LLLnjviD7uBPGkS3gDBm0zD3KsYakluYSOvz5R1dOhB9CAPfJw1ip67nC8cwX+dFROg9tVQiMWDG30HZyqJMIyfsaKzHTwIW+ksGX1YlJHTya4zDbybOP6Et/cp8wP5qN2vT12QpqD3mq2Y39lphx0UOKYufOOfgDAP0ZGkscGiDf/W9s5BXAbdz/sgB7x02NUvN5y2SmNZC4jJs7yF/6Kd6FIu5bDI0pQhCJBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 19:53:01 +0530 Pranav Tyagi <pranav.tyagi03@gmail.com> wrote:

Hi Pranav,

Thank you for this patch! Sorry for the late response, thank you for bumping
the patch. I just have a few comments about the commit message.

> Replace typeof() with __auto_type in the swap() macro in uffd-stress.c.
> __auto_type was introduced in GCC 4.9 and reduces the compile time for
> all compilers. No functional changes intended.

From what I understand, the compiler optimizations from typeof() --> __auto_type
applies when the argument is a variably modified type. It seems like this
internal definition of swap() is only used within selftests/mm/uffd-stress.c,
and in particular is only used twice, in these two lines:

/* prepare next bounce */
swap(area_src, area_dst);

swap(area_src_alias, area_dst_alias);

Where area_src, area_dst, area_src_alias, area_dst_alias are all char * which
the compiler knows the size of at compile time. Given this, I wonder if there
are any compile time speedups.

But this is just my understanding, based on a quick look at the code. Please
feel free to correct me, if I am incorrectly understanding your changes or if
my understanding of __auto_type is incorrect : -)

With that said, I think the main benefit that we get from using __auto_type
has more to do with readability. Since __auto_type can only be used to
declare local variables (as we are doing here), maybe we can rephrase the
commit to be about improving readability, and not compile time?

Again, please let me know if I am overlooking something.

One other thought -- while this internal definition of swap() is confined to
selftests/mm/uffd-stress.c, there is another identical definition in
include/linux/minmax.h that may be used more widely across not only mm
stresstests, but across subsystems as well. Without having taken a deeper
look into this, perhaps this version of swap is indeed called on some data
structures with variable type, and we might be able to see some tangible
compile time improvements?

In any case, this change looks good to me, but maybe a new commit message
that can more closely describe the effects would be better : -) Once you add
those changes, please feel free to add my review tag for the mm selftest change:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-stress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index 40af7f67c407..c0f64df5085c 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -51,7 +51,7 @@ static char *zeropage;
>  pthread_attr_t attr;
>  
>  #define swap(a, b) \
> -	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> +	do { __auto_type __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>  
>  const char *examples =
>  	"# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
> -- 
> 2.49.0

Sent using hkml (https://github.com/sjp38/hackermail)

