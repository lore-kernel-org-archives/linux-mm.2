Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D5BCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7E26B008C; Tue, 29 Sep 2026 11:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299736B0092; Tue, 29 Sep 2026 11:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188EB6B0093; Tue, 29 Sep 2026 11:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E12CF6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:18:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A111A0530
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:18:02 +0000 (UTC)
X-FDA: 85267155204.23.2F4A21B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5AE6140006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:18:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhmKD1uZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OPus6TxJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kxes/HB8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rjsr+u//";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790695080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=iTrA+EzHHieuKJAAD4GRS4CcseVFM7+4DW3Z24+r6QI1C9TVv69s5nYyDvhMXcZgbUz2LA
	F7eraNQXxw8epc5+83thFDC3ouAEOkFMqzUAXr992/IQsZuswnBxPqKGgxm3Nnv5jqnS0I
	UH49Gap04smAkU68SPeOCY/QjsAsMUU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FhmKD1uZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OPus6TxJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kxes/HB8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rjsr+u//";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790695080;
	b=yRp0eXEfEauB1zZNnO6mMCxXVseuT1CNq6xW+7aC2Nu3KSxqhgH0axdFRR/9iWFPfGvUtj
	490sBWsD+2FxOuB99LrJbIXlaT2Rtbn0GQR5TJDZB7mlHum2/12JmI36xPdaqEe35tbnzV
	RYFjXt3z39og5/Y+ZJXulCqAB1vmFXg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B377C1F456;
	Tue, 29 Sep 2026 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790695074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=FhmKD1uZ+D1tKU0bH1FjxjvYxpijB0xvxeMTJEQPhxHMPCLL8KP/ie37FxVToB2WoFg7wZ
	/XNDaKmgwRre+HChcMbXS+RqmxESJNlDvLDq1Lbax5VkPQWWEOomwn4mS27Oauq6xYGAPX
	fEn6pSeszUs/2VvKL3j5+IE7Np7gYXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790695074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=OPus6TxJiV1lnxy+HcUOdE3RaGJOkzLa4lCz7H+KB5MPJhXNqq6ku+YF8oXC0PuqnPkwuZ
	bcQzVDvQHKT4GIDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790695070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=kxes/HB886QxNRlbafjLvkinCh/oM+qExAPu2izP/lplup8KjYOC3+shmurmNZ2Goz2we7
	9oJuKtQipIUmFPMJ52LdfdNXtaw0PaTVqu/K3eN9q0JgHPB9HVup5OvuepiheKDaGCN7+n
	BvZqKXQqlRWk7QwbKmmR9MZ3rc9Ovp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790695070;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dqE/tOpPrIzgQZLhm+Z18s/mfusUAgnOtaHMUgYsSYI=;
	b=rjsr+u//fdqi5GbZtrGiYWKNlkkmAmD2w/rjyRRJMSf/HKbh45tR23pUY5zna8YPLovxL0
	MDYAsrlwjrBy+IDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45047136E4;
	Tue, 29 Sep 2026 15:17:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9oqPA57Wu2qXFQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:17:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: amir73il@gmail.com, brauner@kernel.org, danielzgtg.opensource@gmail.com,
 hughd@google.com, jack@suse.cz, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu, tytso@mit.edu
Subject: Re: [PATCH 1/4] shmem: Report casefold setting in mount options
In-Reply-To: <20260929140011.211148-1-med08elkadiri@gmail.com>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-2-krisman@suse.de>
 <20260929140011.211148-1-med08elkadiri@gmail.com>
Date: Tue, 29 Sep 2026 11:17:48 -0400
Message-ID: <87pkxwxf1f.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: tb6gckijbabxjzzgz5ue5ukfismwdnoz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AE6140006
X-HE-Tag: 1790695080-632768
X-HE-Meta: U2FsdGVkX194pXrv/CCl8iWMcgkoMNuJ/vtTorG89WlDGg+QHbc7jlVhImFxfsWRiZ43G5aVuRmA1DqJemrYDB8aDvhXCr94E8Xp1bjYni89I2a5YudvLEMGKL/5KX6ePdyqU9TlbaeYfa610jXeOWoqoEg/GmBFeelLCYpGILAO1kUxHVvXSHQHvheVn6tpZT8b6tX3B23qaguJGrszn5Ma+BvCZ+EVsE+mLIlt/uPe3Wvo7z/mza5f+0jDivecB+/t9tPSj3zKLrcchTPM0NM/3LZIxPJU1sKVRjMBP23fxXLyIy1ow6wcIclWxajUyxKVgQhv9WU9HGTOrAwtn+8MH02KUXdnxglodlTlxdYt75dvDLpZX3moJz7/p2fVrm5sgjGFj0E3KSUR15UtIqta3zBEj801oQpvw3q3RBaaxLxqmZn0SPgX0ZX/PPb1B8g5jX+whvtRdkNKiu+2Un188+Twy8B2vdsc9DutYWWuUvUbgYmRULDoSm/qOzrrFYVqala3EZSHaiQ69CbtmMOWrmq9bNr6gQ2L1xgs2uVJn/lqn/uZlJMFwKZhEoeX8WWDooZWqI7hl3fYIXHrbkMvF4UHRvzfNgwpmuG8tfjFYVG812diET/O04iaxMXKfkADkKw6HfmLN+LrrZlWQvjQew1dQ81A7To+OjMi0LocGeLT9ilmWubLGlyEulEphp2mlr4jmZTT1CvN/4cOxcU/+M8tnDEBm70T7230+XoFh/Y45rciqNAjLoVboZD92eiPLHtmwnKSn1ptVU6OvQHq7bYsVAKYM/dk2pW153qrfBnjCBiQEw5OkGJrf+iH/xGvPAgWafrJ8ri/Zu88Ne2xSnMhwunR5wpy7Spq0rHjiRXm0hq7b3BaiZlGKg/VgS1JNiPmKaNCxzqhLfgx160WENmU72j8d+Gi00G2X0rqd5wDC1h77ykgej+g+c6hb6Rpi76esJ1x2HKbGEf
 +vRgtT3J
 jvvCY7Wg1Ig7G+BeXRvt7RKPzMozPcEqQM1hLzsjf/3uTpg57uQuSZ3iyQhY0hDYIAaRS5JKGRnQWMucGj09Jb6wvutZ2SBWpNIIGYAectyQVIdfs8x+42Ycx9oHDBnUD9NMXcqaFy1RlrMnAVogoDUW3rVe5dk5b9oADfv1DDcESFxWh20kMLY6KKsRohfLKBqewGNmOlR1OC6xud+gneVEWRwT+u4WjB1dnbujpBY0qVEg8RG3Tv8ZA09zsjdVjYfwx+In9GYpg86cXfw69am/ZErcoUVkJO7HKdUV/64Bw8r2uA9wjBZ/yqvtOc+V41RZ56FtDH6nyvt8Ty9zLbDmKX1OlmU9oh2s3kZIPX9MnMMHmY5Mjo2XC6xwZdcf3dAp1UqtLYKNtpTuuRESMSCfk2FrFvUTEIVo1WSrxpms0s8f2XWkJz7GWXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> On Mon, Sep 28, 2026 at 05:31:52PM -0400, Gabriel Krisman Bertazi wrote:
>> For shmem, casefolding is a mount option.  Report the current encoding
>> and casefolding flags in /proc/mounts
>
> This works for me, on 90ddfbd19636 (akpm/mm-unstable), x86_64,
> CONFIG_UNICODE=y:
>
>   # mount -t tmpfs -o casefold tmpfs /t
>   # grep /t /proc/mounts
>   tmpfs /t tmpfs rw,relatime,casefold=utf8-12.1.0 0 0
>
> Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

Thanks!

>
> Heads-up on one side effect, since mount(8) builds its remount options
> from /proc/mounts: once casefold= is listed there, it gets passed back on
> every remount.
>
>   # mount -t tmpfs -o casefold tmpfs /t
>   [  527.593309] tmpfs: Using encoding : utf8-12.1.0
>   # mount -o remount,size=64M /t
>   [  527.595716] tmpfs: Using encoding : utf8-12.1.0

This is desired behavior, IMO.  You should not lose casefold during a
remount, at risk of botching your data/splitting unrelated files. Also
this is the reason why I didn't expose it directly in /proc/mounts for
ovl, it would be easier but break the remount.

> That second line is shmem_parse_opt_casefold() running on a remount that
> only asked to change size.  It calls utf8_load() each time, and nothing
> frees the result - shmem_reconfigure() doesn't look at ctx->encoding and
> shmem_free_fc() doesn't unload it.  50000 such remounts grew kmalloc-32 by
> ~50000 objects; a tmpfs without casefold stays flat.
>
> The leak predates this patch - you can trigger it by passing casefold= on
> a remount by hand - so I sent the fix as a separate patch:
>
> https://lore.kernel.org/all/ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com/

Thanks for reporting and fixing this.  feel free to cc me on further
unicode stuff.  Will review it right now.

Thanks,

-- 
Gabriel Krisman Bertazi

