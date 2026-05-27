Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A5FCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0821E6B008A; Wed, 27 May 2026 16:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0332F6B008C; Wed, 27 May 2026 16:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A286B0092; Wed, 27 May 2026 16:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D73616B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:10:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7513FC23DC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:10:06 +0000 (UTC)
X-FDA: 84814291212.02.8F29AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93642140015
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:10:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlG7Bzvw;
	spf=pass (imf26.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779912604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5Z4ARx03OBFgTDhNknOHWXfPOP7tDx5AxIk0S8sS74=;
	b=FWUDojz9jppWvj5ilXQ7C8d8W545v25MRj5vKOsyJhtg3BkD53GyJXeeRxlDmmHWqVEDKq
	kNOWOqcqoXHZBMtHMfkh2SPapEB4p+OHO4uEx5ujXOY0QlbzzM3YdbKCvptgIY+tBDUifu
	z81NbC3hde9yS6FbSFsfapF+t9pctmU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlG7Bzvw;
	spf=pass (imf26.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779912604; a=rsa-sha256;
	cv=none;
	b=yTcMRCmyv63Ez8IpWUFSkm1VKYucDNtxUruIDaaMLFtAaZQQTLpqQAxtuAq96OoxigpS7n
	3gfcCQSPQPOTgxAhtQz7Ilj1gygtehE/s4TWxpKFpOmedHJQWBlMMVCVjO1PtcjIQKQ4f7
	jocelVSzUFo7xcqKKeW+sahv0DBSdls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 705B840A0D;
	Wed, 27 May 2026 20:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448A31F000E9;
	Wed, 27 May 2026 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779912603;
	bh=H5Z4ARx03OBFgTDhNknOHWXfPOP7tDx5AxIk0S8sS74=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hlG7BzvwVlbl+7oOOM9vAEreMs4Sk8Uxd+lGROE2dNwYE6UiMrJd9lKXeTXX1tvJa
	 g8EMREXiBinKdu+Er2yJauBXSH/mmIGLI2getLX2MUkZJVtiasfl9H0gBM6dSF4M/n
	 CsFiVxLTvMyJi0QRnM0Z4z5VmfHCJcDeO0oP9MDt86jNRBoZsLz9UphDJoV1oOWl8b
	 hs7cXBBdAP3p7pRmRjyvbjh25iaavwd7txqzilOrJ+DheFF1uQefOnY3Yi2UUIahLQ
	 hqQEvQi3qzUomo7O7dRoQo20T3M40xV/YZ/eILqicZ+ESZ9W2SQXiXyIy9Q5zQ5JXp
	 U4s2I7aT1ifKA==
Date: Wed, 27 May 2026 16:09:57 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 x86@kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, Indu Bhagat
 <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Dylan Hatch
 <dylanbhatch@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <kees@kernel.org>,
 Sam James <sam@gentoo.org>, bpf@vger.kernel.org, linux-mm@kvack.org,
 Namhyung Kim <namhyung@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 "Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave
 <beaub@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, "Carlos
 O'Donell" <codonell@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, "Steven Rostedt
 (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v16 02/20] unwind_user/sframe: Add support for reading
 .sframe headers
Message-ID: <20260527160957.1d3751b1@fedora>
In-Reply-To: <20260521142546.3908498-3-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
	<20260521142546.3908498-3-jremus@linux.ibm.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fqq78nifoaq1o4o15iono86hamunpgoi
X-Rspam-User: 
X-Rspamd-Queue-Id: 93642140015
X-HE-Tag: 1779912604-915484
X-HE-Meta: U2FsdGVkX1+0t/k4oZ8o5tkw29ixpFUJDmTvcs3ObdEdpQYeaUPG2mUM0sCZmXt4zWkpfBHz3pLW54j6hEgW2SfZ9Uj1hh7AEBx5JXAB5LbTh1oUOaebsHXgDRKY3yPafUin8M6wJXfmiFWrdCvmUa/0jQuCBqkV/Lz7EnbBGjb7KQh2hikz0kVreGTPLtMe32nFf7ShWApcQ5YdUATsNgEXk9/w+0jlyXbj7XJou/WGteqCum511iwYkS7FesTBKbXB3f4rD9AUDVIEhhqKi3p1bBHrSpbtD/eDbRQaZQ5h/kAZiSQydTp2v9YxCblZrz/MKCRdqqjH9kALmNb/DWLYYJPXEhn7Tocq9gtg+eAtpPFEnziwNQHugzb7fMn88YWy/hZjJ2VLQWC47VwQpiHEccm2r7nM7mNCW4+XXPosBhHE2Tp3KgQaoJnVGlxmQdDBQ18EHWLdUv5ROAOK/YgIyjGvXPXf73FNhwOfUGpebSOlPyIPMRZcRIX+kq/itvMJWK9YBAnniObYm+sxjQ2wJBDuyUEAL9U3uzMCjKd5PcC/E8j4DwplqeyVBlPGnut7iH+1y3HaRYKJB5Bn+jc7+OLKxAQ+DXHlRzS2Hj0gEGnMZ5B4JMXxx3UWi8JuZxlUFHlICBzi4Ab3v7pik6LGyX7NWdPU5t7Tq9dBWSus1R70Cs4mWX8Vs9x9rGALnbJy2ncI8/V/0XB5FmjmWMsAkRH8NLnZ6a9IjNi01sGiX6vHZSOu/x0yLJ80CUItga7jYG2fDdY9FkkULZo3iUfJVwSVclrPVyWDJj7V5RBmRPpn/1VI6MjP+F1hbG7ams/u0wPbFzxi88yrWa1taKk9S6wDEobk9KAwtwmg2zSNgWS6rndUd97fmzJyG/Kx/Yn9e1m3uuh4ZtDpGPmzdVvnwx7fzrbLjG5ldSlYSvDcWlh0WsJ+ne3TJLJbQ4Ml/P96md0a0pXDbPX7lIe
 O7lkB3Cm
 EhLe8BD2JlOEbv49kYXEpzoG0HZP8ZQGlCPE2WiPI3tv9AKlbOOsJ7xRdJVC5915tdwfDhDY7PgBPn6gDIPuBT2IiZYJ+4DYfHwBhI+od7odm5GZLkedVfGP/hH9o+q3npbd4G++fsgMgp0P1sNkYvuwGB/Q9vo+ILooKS96L2PYt43sDEaudF96wKLRk+ta70L53218jZteq8V3ugwUTu7Pc4vFH9zssKyzZAKmWK2ndl1ffs/X5wf60A6sMZGYrCcDWBf7Ysa7SznZykySHyh6aBvOcfuZISpBtFoNMd2R17quIxWklCuXPSi2bA5DtZLIxJQmtYAH6XIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:25:28 +0200
Jens Remus <jremus@linux.ibm.com> wrote:

> +static int sframe_read_header(struct sframe_section *sec)
> +{
> +	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
> +	struct sframe_header shdr;
> +	unsigned int num_fdes;
> +
> +	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
> +		dbg("header usercopy failed\n");
> +		return -EFAULT;
> +	}
> +
> +	if (shdr.preamble.magic != SFRAME_MAGIC ||
> +	    shdr.preamble.version != SFRAME_VERSION_3 ||
> +	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
> +	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
> +	    shdr.auxhdr_len) {
> +		dbg("bad/unsupported sframe header\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!shdr.num_fdes || !shdr.num_fres) {
> +		dbg("no fde/fre entries\n");
> +		return -EINVAL;
> +	}
> +
> +	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
> +	if (header_end >= sec->sframe_end) {
> +		dbg("header doesn't fit in section\n");
> +		return -EINVAL;
> +	}
> +
> +	num_fdes   = shdr.num_fdes;
> +	fdes_start = header_end + shdr.fdes_off;
> +	fdes_end   = fdes_start + (num_fdes * sizeof(struct sframe_fde_v3));
> +
> +	fres_start = header_end + shdr.fres_off;
> +	fres_end   = fres_start + shdr.fre_len;
> +
> +	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
> +		dbg("inconsistent fde/fre offsets\n");
> +		return -EINVAL;
> +	}

I really think we should also test if fres_start >= fres_end. Because
if fres_start is near sec->sframe_end and on 32bit archs fre_len makes
fres_end overflow, this doesn't catch it.

Even if it doesn't cause issues later, I rather have it caught here.

-- Steve

> +
> +	sec->num_fdes		= num_fdes;
> +	sec->fdes_start		= fdes_start;
> +	sec->fres_start		= fres_start;
> +	sec->fres_end		= fres_end;
> +
> +	sec->ra_off		= shdr.cfa_fixed_ra_offset;
> +	sec->fp_off		= shdr.cfa_fixed_fp_offset;
> +
> +	return 0;
> +}

