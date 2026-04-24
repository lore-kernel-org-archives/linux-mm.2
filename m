Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B84BFDEE28
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF1F6B0088; Thu, 23 Apr 2026 20:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8609E6B008A; Thu, 23 Apr 2026 20:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F276B008C; Thu, 23 Apr 2026 20:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF2A6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:20:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F38F6A09A1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:20:54 +0000 (UTC)
X-FDA: 84691544070.29.AE8F4AD
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 436CD140009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:20:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A2y31Qs6;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776990053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=9prmMr/fIcHvT4Kdkrzhrvvq7KnrqsNR3KWHLAQJlTo=;
	b=REZpBJGZItePOTWakC7tTnjWB6uNohYgxZ3Er6KZUI/ewDyjuXl/fPOudRhUwuB4+256+G
	3Rcz1KT5FCpI3DMdQhvMjN6XYaBOLYSqU1k+kKeoYL9GgM+4Okl8rsAcaBZ4Y7EJWkI7Jv
	2yHAtvHaL8rvUEPtEUDsc0+XDCyoGeQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A2y31Qs6;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776990053; a=rsa-sha256;
	cv=none;
	b=H6HsFyhk32PgcEr+mV6mSuDWPI9nECIcc8R7yWfvdOG9b3ecyNZMCa2/KcDLe0zjuU3tV9
	tQuyFe/EJWHPqKJO4+KRO6G511TXWF2IPe1hS+/7y715wvmgZ90WXvcLcC/THASCsQ1xdk
	YGAPd7zSZyp2H8o7pzqznZyzdZXrrUI=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c79467f128cso2727267a12.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776990051; x=1777594851; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9prmMr/fIcHvT4Kdkrzhrvvq7KnrqsNR3KWHLAQJlTo=;
        b=A2y31Qs6LTBw+FsZuGoj0I7V7CaMClKMo7k4zvHLyhocOHjORHmrqdLC1Y1L2CIWoZ
         xWA/vJ85+g4eQ7y4Z2Pza5Bnte3UN+5xw1FNRYD2zrURj9it0hPrUYsjDu7xSvmCaOaX
         ST47viuoIZyc+ARJUOcuBgqxgCTVUtxbgi7YB8aMpIT0cjH1dGlpQiSc2rT1UBHlkzDn
         06HBub7UB8WpIjTILHlUzz+2PoWb0yVGRJc5Vl00jpkUsAfjveARFMWo370L2XdUKM/V
         GMVUTbRUz6OheP8JFkzKwjfxnlsVGn1PSk8gLaz2zi+CGqmpvJpdQl1q76XBLvWRi5uw
         jotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776990051; x=1777594851;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9prmMr/fIcHvT4Kdkrzhrvvq7KnrqsNR3KWHLAQJlTo=;
        b=DkhLeWAjL/KtR3cCPnAtUeIHHaL3bggsVrwFXspY1FLj1hBTqFQOdEk07SpWNYUiDL
         G/twHp+XhrZmAkBEd5IQfudvld2V8gBg0uI+DfGLFqqU2J/ZMdvP5VvJ4UPbL07x/nLn
         4b/rnMRiAue+3Icykojl6ahkhP+o4iQ0hg0Wwn9qPKkji6eAOA51ICfh6ep/083K6eqg
         9GPRahYkYiav6c0rWT//4ZfzbgvbUKfv8MmqxGu43yszYxjN7qsDVOhEXltVIUuJhmaX
         gFo6lxUS8d17QeSuxkl1ar7Gno5XrPfB74RgbcCMwvSoM+WXk47M50w0FlePB+zfUR9T
         UqLg==
X-Forwarded-Encrypted: i=1; AFNElJ+QxP65iHNDGg8/GdtyTv/wDZHYJyGZwCzyLOT481t3hD9T9jluVPe8l3m4w2DWVkZS4bTbHv5BZg==@kvack.org
X-Gm-Message-State: AOJu0YwU9vYO9H5fg47eP7kx9ENLheO/oXl5kV6Sv30/uCEgMNY4Xw9l
	bQbcL7WOZa/q89IxyK53FQN9JV+9QIS3ZsgJRj73dW9RUklpLiKwjidrr8r0Ww==
X-Gm-Gg: AeBDievxui69f9tRiCl7/jphQkgEVtj3uR3qr0g8yWxGl/ulxbaoe9YI/8P3jIW5jKs
	xN+FWPaExz8yycviKqUZdeksnq35kXi0zYCpmkD+EomkXWPx/LfvRbu11DmEsMSwfdmXCLCK0pK
	tjZbr599o39HIAyJYnjtJOj1xyzqyH454KadfHeTcBpLD/B9YDfIEUQrdjHtPy3lpgZxj4sLm9A
	8dhsDzOUYY02xXeEMY2GFRA4V4ZNDaj9ouAkrL1YR3lojuhdGxD3Cwc+Mx5ZD1UjohFBrjKfjb8
	XpRlpi74y+6zjFCh5EpC3izwnuqtMjHab+fHVpbAGPPEywmKSqkb+uMdJk6Q6L72eg6bvfYQRdc
	FVrKhJI5dzY9aFn0JoeRFdlUM8p8cYNef3B065eHNF1uqMLZqxA4O/+aB4iRThmIsQdgzHEx8m9
	wp4TNWHz8VBMChhkQ7BJwdbgaQWutj36rP
X-Received: by 2002:a05:6a21:329b:b0:3a0:129a:9748 with SMTP id adf61e73a8af0-3a08d76d958mr31549415637.25.1776990051094;
        Thu, 23 Apr 2026 17:20:51 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f92183sm15156744a12.3.2026.04.23.17.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 17:20:50 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap & xfs
In-Reply-To: <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Date: Fri, 24 Apr 2026 05:47:17 +0530
Message-ID: <1pg5tdo2.ritesh.list@gmail.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble> <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Stat-Signature: w6otcr4oqknhjaszf6ibrdh63bw39wu8
X-Rspamd-Queue-Id: 436CD140009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776990053-630761
X-HE-Meta: U2FsdGVkX1+opWvprEypqicmckqtLlALyQlbAwfcPMaNwjsQz91OnfG7qxZ/ujPK8OaT4Wa+Ul8XgPOLY65lNvm/fnD4yM5jh0jj0vCH37J3bryr94gJYnzbCYK8/Hr/2OuLV3GO5qFWHjeXun5njo/t9T8RPQRi2qeN1sQqYSEjotwJssVQbJJs+gwIalOEXxfTWzv/65FC5qdbkep/sRie70deGZtxKeE3A+WZMlOa5lVq5Jwf3PK/8nGIYpADBVSVVfP8hiXq5Dog474K5k/6NmdrGc1GYNup1e+7nFrnYqdFTRk6kHK2UbhTrdSP45r7ki0mSRZfcV59lkA22j8uimwfG0bANoTSkhTevbLyQv/BRjPGin5AaBSiQ85/g2Ck47Fx3MjhYl5cZhkYMKXE1Ff2mM/TQy6KTkB/W4xAOpeXJ2ay1ucklVlRidnE1mfsLWlrK7SivK4psS5umnoBatRnNEUM+02whrGJcK+ToApa5TmzGNMzTCd0pkkhmY6hdekCBs3wKVSzc/Cv/RNGVcstcSVJo43pH90Z01q5AEFPXm5vqc/P/1UQcxSv/Ovq+NL7F6chE/ZR0sWB/SJ7rfRAB2U8DbMYngRGZ4Icp0CfDBeR/dwYU1N/+GXkXC+3qSSCUOJ0HtD5AAfaVcHAVXoCraozD3lL87/o6AVHUpwLfFOTGzYM/xr4fKGNA997qpuD6dwbpBMnjqtw0DLJwBOwFPy40KBvnKrnxryDJzWTpPVKx3grnkuDwwV6GNh9aOYe0oPnhCSzFCad2+i9UHGwZfs3AeBgYrxkBvXc8JM2Z1FMgugj9YC0NXgjvdWSXTetxpayGxmT5NSVipYYSLsA5NqJd82WV9xUmMJ78wpxgyt7cLkU27eSqbrHUy19RllV1AHK/ccttAsrY3zAeeYJ0oFnfs6i0OBwmGbtRmFa/FIgqQkQpZhhcltHXGb7/DmR58/ec9ECkhL
 WjV8JmXe
 NINiIlWu5rab4T1wdPYpm0q5el9hcwsCYe3X2gysiqn3kOHcS/Qk4iaPjTzoidt0k/3wm5XMZOufjuUDySXKDILbHjgroVrbvnjA51phVHrBSiBel466MUmCGb15JhwhQS6w716kiL2ZRYYeSEUCHpWYzVr6U3gTQ3DOTfMh+dc6cB61W3/04616fDUH+gU4wThFrK7pRecDN58DPB+ydId8WLhL2U5XNCwhaBeW/lW0EhpaNXVHcRcY6RcgF8hFtFTGAmdEi/Jkku1PQUbz9UMHCxBX3WDmOzqgF6FrReU+ugfnhyZdmC0JOeicEMbe9oALbvaj0AxVgg6Mbl8ahmpS7DNaz8EKdbkujaD+Np5mRRhQ8jzpXwgkIJt5x1Yf6zzScoqFxWOc6w3MR2bMG5EzYzE1VGUCwIj3HrSW+Z0QvPdbB2/FCaAm/uPBHDhq+JVP1se+N8e+lmXQ8v4AX3Wi/gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ojaswin Mujoo <ojaswin@linux.ibm.com> writes:

> On Thu, Apr 23, 2026 at 02:25:43PM +0200, Pankaj Raghav (Samsung) wrote:
>> > 
>> > 
>> > * Testing Notes (UPDATED) *
>> > 
>> > - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>> >   xfstests and these patches survive fsx with integrity verification as
>> >   well as fsstress parallel stressing.
>> > - -g quick with blocks size == page size and blocksize < pagesize shows
>> >   no new regressions.
>> 
>> I am hitting a very strange error in generic/127. I deconstructed it in
>> to two commands that can reproduce the issue:
>> 
>> ```
>> $ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1
>> 
>> $ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
>> mapped writes DISABLED
>> Seed set to 191110531
>> main: filesystem does not support exchange range, disabling!
>> main: atomic writes need O_DIRECT (-Z), disabling!
>> short read: 0x0 bytes instead of 0x6c7f
>> LOG DUMP (1 total operations):
>> 1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
>> Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
>> fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
>> : Operation not supported
>> Correct content saved for comparison
>> (maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
>> ```
>> 
>> This is on a bs == ps (4k block size) xfs filesystem.
>> ```
>> $ xfs_info /media/test/
>> meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
>>          =                       sectsz=4096  attr=2, projid32bit=1
>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
>> data     =                       bsize=4096   blocks=8388608, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=16384, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> ```
>> 
>> The same test passes if I pass `-G` to fsx parameters(disabling writethrough).
>> 
>> The error is coming when we do a read operation which feels very
>> strange. Could you run this in your setup and see if you can reproduce
>> them? I still do not know where the issue is coming from or it is
>> because of my test setup.
>
> Hey Pankaj, I think the xfstests branch I shared might have been missing
> one small fix that can cause this issue. I've update the branch with the
> fix, can you give it a try:
>
> https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2
>

Ohk, just noticed your reply, after sending a response...

Thinking it again, I agree we should just always ftruncate it back to
the original file_size. Because we might have changed to file size while
testing the writethrough support.

Thanks for fixing it! This fix looks right to me.

~# git diff
diff --git a/ltp/fsx.c b/ltp/fsx.c
index c9901f65..720bca83 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2095,7 +2095,7 @@ test_writethrough_io(void)
                return 0;
        }

-       if (ftruncate(fd, 0) != 0) {
+       if (ftruncate(fd, file_size) != 0) {
                perror("test_writethrough_io: failed to ftruncate to 0\n");
                exit(132);
        }

-ritesh


> Regards,
> Ojaswin
>
>> 
>> --
>> Pankaj

