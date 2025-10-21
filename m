Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C65CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D588E001E; Tue, 21 Oct 2025 05:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E158F8E0002; Tue, 21 Oct 2025 05:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A838E001E; Tue, 21 Oct 2025 05:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3ACF8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:33:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89CE01A0342
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:33:19 +0000 (UTC)
X-FDA: 84021608118.10.5ECAC37
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 408B910000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:33:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vsxheCdR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1XLWtYVd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cT5C10Rg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dA7tqWQ0;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6jrOugP6myyf/5E3eorz/pv7W1Npv0nq8xpovchIB0=;
	b=GzoxnHR9Gy7zbI0UeQuvPwU/8dBfUEuU9egKFBBCqLmt61rDjnpp+o3MXZOH/WhXs7MkD/
	ELCD5AFaXM6SJyMQBT8x+zZTrfAriouiPeC9OBR99KFCB1a7fsxa7uWelHx31Fy5843iDo
	/EUQfY8QEkblvYfVohCZASf/Ujg4vE8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vsxheCdR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1XLWtYVd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cT5C10Rg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dA7tqWQ0;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039197; a=rsa-sha256;
	cv=none;
	b=4e11JLL+3Vrh7tCgkD4b1ipnH5e8qpOao8TOdl/5RSByB4PFYsmKsz+zOP17Pckbp7+guW
	uryT25ptPSp1ZKoxXc2jssOD3z9VGlEhpAu822Nok3S1VHpxFLpXEhMeA1SJhDJ9423jz8
	dqlhQ4+FDgP9HI1AcAcZR5XdR8dbTdA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 838F81F789;
	Tue, 21 Oct 2025 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761039191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6jrOugP6myyf/5E3eorz/pv7W1Npv0nq8xpovchIB0=;
	b=vsxheCdRjrOHhnzU9sliWiF4N1NvoOQhIr4hyVbo6LiXsDs0Hkk9+OOkVI/H+JyMTFvXBE
	BaByXhHFIUJ0GznoGxDdH/9GOuS7Zm2MMgZQo3boWzU4G03jizOIuqNu9FrnwEDV3Iy/S5
	WXpNfyOV6nkfcoivEHiCH0398uo2qaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761039191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6jrOugP6myyf/5E3eorz/pv7W1Npv0nq8xpovchIB0=;
	b=1XLWtYVd7w2SRA+Gd1uEk/ACLhQAyAR1CPT1894L0N4uV5JF0eEZS1tRZN/cCM3+KE85P+
	tc9mKrOAfVU8dYAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761039187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6jrOugP6myyf/5E3eorz/pv7W1Npv0nq8xpovchIB0=;
	b=cT5C10RgzTrCqIKTEejIt3D16fqA5h0XfPqNjSWvFPHszuWGmEqQYe15/q6wRAXg8kewy+
	GbVaVYp5occgadJn+pv2rgZw9wwV7CUsTTvNC3spv4W5x0JBTzj2Ct4ZCRF272ve0v/pjx
	LZucASHxDmUeJpj+6TU0RIOu2lR8IJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761039187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6jrOugP6myyf/5E3eorz/pv7W1Npv0nq8xpovchIB0=;
	b=dA7tqWQ0sKLRQ7FfVYSjol2Z/XT2xHVSi0VoLKONvL3WlMMwsLpcdBrpuzwlVsJ2aRUXlE
	bJ9NN2iW0zzeDvDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7164813A38;
	Tue, 21 Oct 2025 09:33:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kCaqG1NT92hITQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 09:33:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 159C1A0990; Tue, 21 Oct 2025 11:33:03 +0200 (CEST)
Date: Tue, 21 Oct 2025 11:33:03 +0200
From: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	djwong@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <rizci7wwm7ncrc6uf7ibtiap52rqghe7rt6ecrcoyp22otqwu4@bqksgiaxlc5v>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <32a9b501-742d-4954-9207-bb7d0c08fccb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a9b501-742d-4954-9207-bb7d0c08fccb@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 408B910000D
X-Stat-Signature: 8swgro79m6kxsdf4rcm36y53smdjff77
X-Rspam-User: 
X-HE-Tag: 1761039197-713657
X-HE-Meta: U2FsdGVkX18Ch6Atq8tQvPBkHxYbKsr2RbV7R9w4mziMNqbIj99V9huS94a7pzjwbfEsT2IN9GP0Zwqpx0mN/BEoMZyDFbqhOyHfuh81T4BddAV6P+Cx0tv5FFBzS+T8GzIX34r2qMmxmIrdtzXKEygGMzGW0NueAdS4diyprZDkJ9JjMnLPIrUyG8rBg8TOxpAlv9Wbq5sGvOSJrVMtEU1lcB43/VU/hnD3MeeYJWV50uV1WsuACav6aiw8sUPPx/a2dblMPiULHeOLYvvVjvJXZ7JlU+fWtCAlZcfWdq5VHyru6kBcXE2Bx5i8owPbWpwLoxqCFaIH9KFVmpWXsPaqPJgRjbGiZJR1mF2EW33gYs+0C2AYctHIla8cjFlVS6jlZ1VX+jp0Yk/4iIpZ071d7mloJ2ybSOsRzKs2zkj6DfULm8S4tiQ6P+zfYhq4AZBTwei++qS6+bRktJenkb7ITqBi6i5crlMvkFhhT94acmhM/ci3ZY4+VPFjnurLlbvzwI2K6psV3YxliC6ISnFfETkaM+bzHRmFaSfSq7pfhDiZNgF03Wys8hgzQcNy3WWJz8jGJlTgyzMiFecoUzVffql04Smr/1leLUjmu+dVGUPZ1ye1jhQWEuRt05aBZVgaGLC2pwPeOHHzeYI14ZGD46Ho8WEZOW6IcBVCBdkMryxJ4Drl0buMwB0VQ+VCO0RSyEM330DTr3cYG3xmHzDMaz8KFDQEsj42Q/JhCimxrMgBrMnqQFZI0fgu5muBaTzA2hPy8GCgKK8pgD5YsGDar6LhHptxvY0DA4bSkqRLvXYS/+o14RV8IqKAGcm2gxp+oMpcf9ZEgAgiOnFuOHWBPzRtqho6FBbu+MyXMNYq2X2wlgoGOmfm+4cRemVaFqcI3oXPcI/Jrbfw07YBHakMvgSwxOj20IxlE2d7ZioPLS9jMc+sdLV/3zi2cmKgBxfsez8ZAsnEpzrY7Ue
 3SECZOMx
 p8NYnoTYHwKhEwDpqQ76Qs5crYqzQhEOoCepSK2KR5gOkqMZ/7Tknv+EUtEADPH6hJgYHM9mhnmOpUXsqlrfwoUnAwN3oe+0oloaVEf7CbnS9lNvv1NovmquauQ1w6oJPCijRXScZcXnXZkmrc1Gdw2NCqGa8JUAQRC+czknZDLgqLLErWCMU4mct+xKCqv1LIR+HA9TXzGxsrsCr4j+cs1MKMSMZpG9RTD+mWcVOtYK81pVjWEOeCL5ioYUpb7IoKyIs5dpm/OcCSF9Scj3zWVNdsaW5k7ApWlXL3GeAEFerxJi5L0vRNi07fShK/d5spe/mWpnRIJYQ83jK7WVzXzlX7EmrKV0jBzxQ8jsPAF59cBfjgTkiNr5dMj5x7Q20y6ZPg5+9mDB6Rrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-10-25 09:57:08, David Hildenbrand wrote:
> On 21.10.25 09:49, Christoph Hellwig wrote:
> > On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
> > > Just FYI, because it might be interesting in this context.
> > > 
> > > For anonymous memory we have this working by only writing the folio out if
> > > it is completely unmapped and there are no unexpected folio references/pins
> > > (see pageout()), and only allowing to write to such a folio ("reuse") if
> > > SWP_STABLE_WRITES is not set (see do_swap_page()).
> > > 
> > > So once we start writeback the folio has no writable page table mappings
> > > (unmapped) and no GUP pins. Consequently, when trying to write to it we can
> > > just fallback to creating a page copy without causing trouble with GUP pins.
> > 
> > Yeah.  But anonymous is the easy case, the pain is direct I/O to file
> > mappings.  Mapping the right answer is to just fail pinning them and fall
> > back to (dontcache) buffered I/O.
> 
> Right, I think the rules could likely be
> 
> a) Don't start writeback to such devices if there may be GUP pins (o
> writeble PTEs)
> 
> b) Don't allow FOLL_WRITE GUP pins if there is writeback to such a device
> 
> Regarding b), I would have thought that GUP would find the PTE to not be
> writable and consequently trigger a page fault first to make it writable?
> And I'd have thought that we cannot make such a PTE writable while there is
> writeback to such a device going on (otherwise the CPU could just cause
> trouble).

See some of the cases in my reply to Christoph. It is also stuff like:

c) Don't allow FOLL_WRITE GUP pins or writeable mapping if there are *any*
pins to the page.

And we'd have to write-protect the page in the page tables at the moment we
obtain the FOLL_WRITE GUP pin to make sure the pin owner is the only thread
able to modify that page contents while the DIO is running.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

