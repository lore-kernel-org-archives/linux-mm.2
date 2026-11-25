Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3803D606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8aPGXQ3
Received: by kanga.kvack.org (Postfix)
	id 415D06B0973; Wed, 25 Nov 2026 05:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7586B0975; Wed, 25 Nov 2026 05:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B53D6B0976; Wed, 25 Nov 2026 05:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0095D6B0973
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:00:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B0121C49A9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:00:18 +0000 (UTC)
X-FDA: 85473196116.24.45F85A5
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F58A160019
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:00:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t8aPGXQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600816;
	b=BsOL0IJ2rSMsLu1N69n44yo4PKnS7kBUoEylWqEnGJL8swlngkOU7p4fiqKku8ZMjy6geP
	VIN5NHD+mEF2F9mZvyuwkgq/xHvZPEVQ0y0sXU4fQC3c3F0J4W1G4aO1cgGrTNwMBG9MVn
	u9BMkYj9/bvevINubagoM7xJb2YpYd4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
	b=IVP0Zv40NSR7cq6N9IyI1BIENpddiv0+6qyLQZBk6W0JjIb04dhVvvnfioyfYKGSqAoQ3p
	ug7TAP7Zwe3m1mn/2/cqQOdQJjvJW5+PvYb3rugsEfctuMCexlEvt+yfDdAft4gHROCF18
	mGMMPkF5H0/IMVI0YtC0vUgQFRDr36I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t8aPGXQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48dee593f18so5190563f8f.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600815; x=1796205615; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
        b=t8aPGXQ39tuuG61HymLyaJpZeY4rIMmRnDDB/XidVgsmzavlOIyuTR9uDymNJxP9KR
         DiYF3nm1r0lsv6e0f553makNBqOl8auNZ/0Oc3+W387wNSS6BtytAfCckf1bm9NUTTJs
         MRGQBsfA3dEsOaMJ0cRjvSZSsnJuYpeDqjRBiOKZMrfVJ2Gbq6oq+XvdLMgySJLnyzR3
         ryPl+/DaYVWPogeIz19ZtNBk2UJxLhqUp8XnR3pyE8MHoGHxyq2gTrHQzeudso3dTt8R
         j5X7TwNPGbNJJznLsP2p3HeKe4KOkj5OgYaDMtYSq1124CvV2UYEUIxG9MDF1EBA1pus
         aSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600815; x=1796205615;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
        b=qqsXKKzuQopUj5V010dtp5Mt/zeOnbur/XxKR4sb7/BtviEQLdmSnjn2w7RJi9xDEi
         fqHuYCEW8+zrhjkCzjofMi+8XCA/qPauboB2s8lN83AhWO8ycQBlI8a5kAzgYL54vqYb
         1TMSJukjLEYZxxLuGDim4BhriVdbbpOdj6sTcS9zW9llPQbBhkOJcH5i86YINd6GgiJU
         uSXufKIbBBsIIPQl6hSG5Fj25i2Dzfpk6/S2mvBl+Ic8nZ7qyt41oPtdKi93nSk+RaCr
         /nL5wFdvmpCNfTGq1RvLT/+CtUo/YW0YbLKO5aqZMNebSMPddGup0N7WdCqXT8Dr5s4n
         2V/g==
X-Forwarded-Encrypted: i=1; AL+hErGsnyxXQeyYGrpHhzVKMAGwo27hgwgex5jdk8Mt4yQW3KSLRY91egjHjqpvVr0kzAOYQntwdlFTfQ==@kvack.org
X-Gm-Message-State: APuU4Z8dhmtQJA6vtvWhPNYrPDNXWKMp1Oc416nlaNql9UuWpLIYp9Kj
	TOqj+Z4tIxbmJcDSY1veGkaPur2pGr3nEd3NkQYGaSvgR3DxbuQ8l2uY
X-Gm-Gg: AZFdTZcZ9erqARNbqMMrevvrPMXpC04zvqvBo7w7EQXBEdeWGmVfGhSMveUduZRca8m
	U+KQsKddVJaAF05HIHVll7EqOjgqvyieZB3NCCZdexNsn0jVfBlbMrM8rc6hKaFzVAfTts2BpbH
	BRkXeBsC4QBvW/2V1N6YEZRti9vPuaorZSnj2GW7v7Z9idSHS97uxoM0o2lRoczCvA7PoulHDS0
	X4ujTEfnNDyUuCWylOZ7FlDaX6+6xs4/u6fFWwV0/OXRc1+BWekI/a6fVDZvT037OhaNlGAl1On
	A85N9EHwKZRuJRvDC+yHFkCn1rhBB5pRHi7eL7smp/6CNxASgLulhGcjgKuAqliEalgyKIKQr8g
	vA9gF3nogkgVLBIoEtCkyo4NKr7m35lEUPeoO+wBLyI5jjLUqDWlNciFF7f/+ayP4B8/PqxNKYy
	vzW9eJxYquB73r39YTH+5BQbiiEybz/CtmWXOziAQ0SBjko2/JhT4OdnlbDm5Fbs701n6rwqRfw
	R1+ipHMz5FFwhGfE6zR3vusr2fufSqPCUfvHYmWRZXFFOdJjjVeWtpd7wT1Iskc5zb0vThuP/2E
	098eSge16RWn26Q+h7JZ3EtUjmo+d0KtXJRXgAhondEcvq/M1QjzjR5hpaM25mmEDw==
X-Received: by 2002:a05:6000:454f:b0:48e:6419:ddf2 with SMTP id ffacd0b85a97d-4abb2168ec7mr22189006f8f.17.1795600814661;
        Wed, 25 Nov 2026 02:00:14 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm30001376f8f.17.2026.11.25.02.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:00:14 -0800 (PST)
Date: Wed, 25 Nov 2026 10:00:13 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Finn Thain" <fthain@linux-m68k.org>, "Bart Van Assche"
 <bvanassche@acm.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "kernel
 test robot" <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>, "James E . J .
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Message-ID: <20261125100013.356bc7c7@pumpkin>
In-Reply-To: <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
	<0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
	<CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
	<669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
	<8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
	<85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
	<f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 9F58A160019
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ta8eqam68wo6rfy4hkpac85dxg1if5nc
X-HE-Tag: 1795600816-76239
X-HE-Meta: U2FsdGVkX19Kv3A7MCTXmWDvwxdUSxNXhVR/ykJ064rBIoiTo3pJ9C5rKS/zkVNL4MJF1LPoquGwSnpJj01+czMlUEl2V7b8eeD3esdRgemMB86DDRqurRJSaMJeBmYckW7B1WnPWby3PCkxkplCsWRwknJSr1xyKtDFIveiZWJAhIdHoqnV8ggmvnpJoh8zMRCeh6/7jQzZhTYjuSLfOMTPs/ufjtqNCY7hqU6Kqk43S1QCTJaJJ56135Xcy4qTcqAWrwH6OCNyDajcpotmL9KRmLbgXdWbRwmpdK1XQdcOO8M+NLcbEy3zHMJrYkbxZUn7JQ1Lb+PCRx8VM03R6/Fz4MnKOmi3X6uvuowyHcUkQZZYeZyvD3ijpbIu/7sg05bhM5wLu5JvCwXtwURyeVsNjW7MAvRFlpjCXFhYyYPkRr57N6NwlRXFzynS3/ofv1cCDdcuAi1fjf56GsdZ270bDFs+aReHwJQ8HAitU4CYk4DWQM8P+4oDKkHvjs1c+NAAS1J7MGV8FjrIjNKRvCClTSEQPRuDCWfpNLE8Tipj6Q12vchEI5jy3KFoH1BZHuAEYtZxa+XrB3SHqNUN7TkvqmIkUs9Z+0sMJYiWVxl24Y1E6eyvUjg+z8JZ6Um/IZZf62ZEYKINAQZQS1Z6V/xYD4tTbTLXOGAmmolk3UFvPBn0eOx3LoMoqkZm71VSK1l1CDvVFSabYKIUxPTtjIO+2IPMgDy8h0uazAsbcETh0NZVM7mml2IJgNrNRzIxnWaUprGJjvVl+/iGSJNj+sQYd89usnQxS5meQnMbPE1Lo1n3srrCzKwlTJ3SzDyOKpLF8rt/SzvyeHIBCaOoFaVbq8y9bIwdGBWzwfjxutN4TezUJG9B89SOcitWKndGW56czcZAhFzzO/Wo9xmgGuDMqvr6QEQ/XnGyw5JAWkhbQ8DFcTFIMzOKG2ugynpcJMaxUI+UbQUZBIPnv01
 TZAQ3qnT
 5BRx7uvp0+PP58gyZQLigcJF8gtKTeC17o09/2OMQBRsGg4mWph/m8WiNnAdS8DW475JnOvKZFNZoNHQpYFOS4ZRwqb93iIasN5Rnd6dcwvRMHce9IFgchg5deT0itOybDBV6Zc4U7u6C0NIQLpvi7wXQpkXh+AjzrozGF6w0aDUzdVFQCSa+lCqooi+uh0ARjOYePqiRJkX5sif1x7u3goCA+Vx/MkAfXhv1PHCtMi5yrvWaG05CSeAIYC7SkY81eQ0PiQWOG9CMXwjWTUNW4jWBQoLg16dPvYff3S7wJWz5lKV7hQim9QqaaWlVCCp40UX4Ys4zDrKam6pqm+ak5QORM5+zS8PYCZ2n8Xxdlo/T0xQQApD5oRtwxGiTWfWG+9p8ThbxmTrb0bkWS2p786AnRNGmQlM1u6CWGZbpUvkZu4dmdUitP0dVNmLXyDJL6LhvWv1C2eYrmvlmcUAaMS2wZFRgIQVlP8SEmxehvOMtOmDH3e3Vr4HOuRJqTg8//Rt+UScGTOn5BnSERBNijM6A3RkP3e12fGUGaFFKFGIOhvkPk1dTdTHevryz9PCnEFsJITRnoUeHY98JedfP3QqsyyKBRpYRkPSSgnlmurXZ1Qd1Zx/X4oI8dccO73ixi843qFuX7QnyHrGp/TeBMgrG20/aW05Lbzb88RYVVIzT4ngo2cM3gcd8LB9Df7K19tLiwnPEwmdx+P/TNB83RE5tYzikPgQsJn+uLTtSeIblFCgaG1XY6M28/DvcEmuuruPgqUXaVYEQMPivU5uzpmKZCyYFC1LqpHhMPWT4ESERKehh5N62+6BYFUjm9iWHdpoX8mNCKW37YcOeYeJ8aRfDCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 11:18:19 +0100
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
> > On Mon, 23 Nov 2026, Bart Van Assche wrote:
> >  
> >> On 11/23/26 3:05 PM, Finn Thain wrote:  
> >> > Yes, two alternative solutions were submitted in March (either remove the
> >> > assertion or rework it). The build bot reported the problem again in
> >> > September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> >> > have much praise for that*, so now I'm leaning towards the "remove"
> >> > alternative. I have been advised to keep re-submitting, and I will do so
> >> > after a suitable back-off in retry rate i.e. 2027 or 2028.
> >> > 
> >> > *
> >> > https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org  
> >> 
> >> What an LLM came up with after I asked it to fix 
> >> https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be 
> >> found below. One of the comments of the LLM is "This is essentially Finn 
> >> Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
> >> comments from this morning applied". Sashiko reports "No issues found" 
> >> for the patch below. No Signed-off-by from me because I think Finn 
> >> should be credited for his work instead of I.
> >>   
> >
> > Thanks, Bart. I'll take that as a vote for "rework". There is an 
> > associated risk though: I can't test the patch as I don't have access to 
> > suitable hardware. (Perhaps someone with such access will volunteer.) 
> >
> > Whereas, the "remove" alternative doesn't require testing as it doesn't 
> > risk a regression.
> >
> > I have a question for your LLM. Sashiko-bot said, in response to my patch:
> >
> >     Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
> >     when len > 0:
> >
> >     drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
> >     ...
> >         return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
> >     ...
> >     }
> >
> > I don't understand why the patch from your LLM did not raise the same OOB 
> > access concerns.  
> 
> I suspect that is just from Bart specifically calling it out in the changelog
> already as a known limitation "Do not modify the memcpy() call in
> qlt_queue_unknown_atio(), which still writes past the end of the 'atio'
> member.".
> 
> > Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
> > members being added in the wrong spot in that struct but can't prevent new 
> > struct members being added to struct atio7_fcp_cmnd. Neither does the 
> > assertion. So the "remove" alternative doesn't have all the disadvantages 
> > that you might expect.  
> 
> This is probably just a difference in perception: atio_from_isp and
> everything inside is clearly marked as a hardware structure that is
> meant to align exactly to the 64 byte cacheline, so it would not
> make any sense to change its layout and add more members here.
> qla_tgt_sess_op on the other hand is clearly not a hardware structure
> but an in-kernel one, so it is quite unexpected that one of its members
> extends past the end, especially when the other three instances of
> atio_from_isp in data structures don't seem to do that.
> 
> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
> >>   		add_cdb_len =
> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
> >> 
> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
> >>   	if (u == NULL)
> >>  		goto out_term;  
> 
> While this does make the current implementation more correct by having
> the correct length, I'm worried that it just ends up establishing
> the complexity more in the sense that extra_cdb extends both into
> the padding and beyond qla_tgt_sess_op.

Isn't the struct also embedded in the middle of other structures
so can't end in a flex array?

> If the driver is still actively maintained, it would be nice to
> reduce the complexity instead, in one of two ways:
> 
> a) make atio_from_isp naturally aligned by dropping the bogus
>    __packed attribute, so it is actually at the end of qla_tgt_sess_op
>    as the driver was written to expect. Note that having the
>    outer structure as __packed but the union and the inner
>    structs as aligned is itself problematic and can lead to
>    undefined behavior, if some code ever takes a pointer to
>    one of the inner aggregates and expects it to be aligned.
>    The only effect that I see from the __packed annotation is
>    that it forces expensive byte access on dma-coherent memory
>    despite it being fully aligned.

It looks to me like almost all of the __packed in that header
are bogus - there is one on an le64 member which could easily
be on an odd 32bit boundary.
What it really wants is an 'error if any padding' flag.
(And maybe a compile-time check on the longer structures.)

If the hardware does dma onto those structures then you really
don't want them misaligned either.

Bag of worms :-)

David

> 
> b) rework the driver more broadly to never actually do any
>    accesses beyond a struct boundary and make it work with
>    sanitizers enabled. One way to do this would be to
>    have a separate isp24 atio structure that is not in the
>    union but that encloses the actual maximum length.
>    Not sure how this would actually be done, but it appears
>    that the current design keeps causing problems, see e.g.
>    091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory
>    access with big CDBs") which adds more complexity around
>    keeping an extra copy for it.
> 
>       Arnd
> 


