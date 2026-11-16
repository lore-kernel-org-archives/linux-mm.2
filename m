Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06517606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owEn5WCA
Received: by kanga.kvack.org (Postfix)
	id 28D6C6B05B1; Mon, 16 Nov 2026 03:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217616B05BB; Mon, 16 Nov 2026 03:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E01C6B05BC; Mon, 16 Nov 2026 03:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC03E6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:19:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E11E16060F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:19:39 +0000 (UTC)
X-FDA: 85440283278.03.394AF88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1938120006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owEn5WCA;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794817178;
	b=sarxTwIOp81JQO0sOuPDnoVwgK2oWeTEPJJsBAKi0p49uxLW+tTZHccP8mnqKegZVi5+9B
	vq2ziTLqjjUDuMnrEvLIVc3oaquKEG9bwc0OU7HDp9rmNfq3gyeuj7aMIIL1OiCrXx/xSB
	wAWVP2Oa2ShZEYI7q4XOwRpGaTXsIgw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owEn5WCA;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794817178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dp6lgbEcVom79R8IDLgyLdypERcbXJQqocjZDGuwhxc=;
	b=4FaeBaML6UWpY9IwVJMgoxS68a0q3yu5VvRimXcIEvyInmIECYtX7UCMhDjcGboY4zoiwT
	VGhlQTnAtEHpPmddivF92eq6GLrxXpNuhuDs7tp1UITQe3u84tnXrB5sCosNZAWOgtE+Gc
	EqL9YIWRK1d5LU+lwYP6AYARbYHD2yA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09E9143AF5;
	Mon, 16 Nov 2026 08:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904791F000C4;
	Mon, 16 Nov 2026 08:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817176;
	bh=dp6lgbEcVom79R8IDLgyLdypERcbXJQqocjZDGuwhxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=owEn5WCAgSzoxVz51gzGvHS7spNutLxXk1ptEdUqtxQ40WnJHkMvfbkSkjtjpS1Qw
	 Sx07ZZIzdwK7JNRq+q6AFvP5F1xw4+casI3I0hlKaavWpmRMYmvVpQFMoSHTkGi4ZA
	 AmAj/BFY+NKH0vQNzT14oC6sEiq0RGSK/C4qk5aejO493Av+CqSy6I9DWrGSz3RHzm
	 g+OwvnRGbFx91fKg3T2UEwaUkZcIB9/O2Nd60wwmEZRtxvaObWzl5eYVbDu31CydbB
	 q8yShCstJ8F4xqMN6C/grxv5i5WImOKzeS2prsLIbAX6wZBjekmX0UYj5wtHcuMZk9
	 MQwudfDlsRrOA==
Date: Mon, 16 Nov 2026 09:19:30 +0100
From: Christian Brauner <brauner@kernel.org>
To: Fan Wu <wufan@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
Message-ID: <20261116-ungeziefer-notdurft-scham-bdf3e3e4e43b@brauner>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
 <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D1938120006
X-Stat-Signature: 6topzqtjqz5sjdscctrks1iwkqykkkna
X-Rspam-User: 
X-HE-Tag: 1794817177-245806
X-HE-Meta: U2FsdGVkX1/AoIeRQXxuY6DGkynbJ67Ah/XSE0P0qZ4OLdKpmZBr3xkib+8JaE/czaemDSDF5ttxXCMUBoio0/5M9KOy3uagibt1NFmOBg9VNrKBTkcrxFKESGkMICDg4V0KUPI2hMAj6G3pZ4KxUE7oQx0NXSJ5iWa22UIZyzwrIvUDAGHIymbGSjWTWaM82rYmlrXXw2qBxQX6j3wf4aPs9twF7/NC0N+O4Ahfv5f+Wcn3b+maIt2sEgjYkbT4vIad4eron5815zCIK/eqL+kYMMDHi3m99DkFNEAQEb3eWYZIgTFTV+GzdEYDAtzTiP1oPt6W9dXU6IB6EwvJJcE3ItoDgNOwAUwA8k0dXIf7ZPhukH8Ty5H7WbOmNX3BXWloGEaD1clz92bwl3sUVa25tkT1gnm7P2A9jP/WNalvLk1nbX6PqG3esvCk/kzwnP4McVJ3T0jzLrfU985LJLnKYlOey0WeVwMfhq6gGhxfb/AuFyg3DRXlNemodfnEc9oG+ISqzLzncZJ8x3qPX3uhd/jKm9vrGkXr50huBt0w1AYT9CS6cwWAx24GF/VdK/ty6kjUGJGYixEEiqyCnSwWyswTPGyg6vZKtPgm/NaujmhBmjVa/ue4qtWH3wtctDMHK4SiwrgxrkDcNaNe7z0MrCkT3dZjpsPCHqy9/qmyMChA8xhdWw2NPTnT/80Jm1IfNM02cs7KBCGD+pyTYklOCm9RYooc8lriPrZ1lpqlbYuKtr0srI3/T/aHwfZFOmuWHcLKfhhM3mvYwaOLE9dP6PLDgJQIeI9sqqSsS+bcXdZ7roDhG/LuExtSKm1ObQEwM3EtUn8SxdIDF2NVv1aAogC8hRLg53hu3tJpOqIHxJ3+ISADwezr1SIycg59gl62HbaWizA03gIss8iQXjkGWp0e/E3x7dnYQKPNjKlf5zia8vK01agOqfw1yE0lc22cFmZvMb8SzIEv6J4
 sOfk0ZZw
 zDHb85MnSXQoDhiXOlj4I6MPPjQe4eaaJGHucI8kpfHUcvJp1QIj5zzQlwvz7VvJsT+tTh042bDRV3QflQxPk6tPvq0qSdpATPx8x7Zxo/r4nF5H3UX8JxwgFTVrPtV82yiB+ApfgLZirZEPBMJ+u9Xj7XTW3dkfrl8fsFJLmxN7BtgdR08hOtimk/ypPSXjhY7UWYMPfhOSbDtd+yqDaikEbiUS//rOEBD8kucxzghW4zKqaJ31WvM+LWswOBbVM3gg+QYKOO6iiL/Fflocmoqc0gB7BCSiqFY9XwyyWEllJiOrr9FoaXzmxR//BtOWptppfkprZBTBnUhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 01:00:55PM -0800, Fan Wu wrote:
> On 11/15/2026 6:01 AM, Christian Brauner wrote:
> 
> ...
> 
> > 
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > index 4a7be96c84f03..3751963509df4 100644
> > --- a/security/ipe/eval.c
> > +++ b/security/ipe/eval.c
> > @@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
> >  
> >  	if (file) {
> >  		build_ipe_sb_ctx(ctx, file);
> > -		ino = d_real_inode(file->f_path.dentry);
> > +		ino = d_real_data_inode(file->f_path.dentry);
> > +		if (IS_ERR(ino)) {
> > +			ctx->file_err = PTR_ERR(ino);
> > +			return;
> > +		}
> >  		build_ipe_bdev_ctx(ctx, ino);
> >  		build_ipe_inode_ctx(ctx, ino);
> 
> 
> I think we only need to change this part like:
> 
> 	/*
> 	 * If the real data inode cannot be resolved, leave the bdev
> 	 * and inode fields unset so the file is evaluated without
> 	 * dm-verity/fs-verity state.
> 	 */
> 	ino = d_real_data_inode(file->f_path.dentry);
> 	if (!IS_ERR(ino)) {
> 		build_ipe_bdev_ctx(ctx, ino);
> 		build_ipe_inode_ctx(ctx, ino);
> 	}
> 
> 
> This also avoids the missing audit issue noted by the bpf bot, and we
> don't need to add file_err to struct ipe_eval_ctx.
> 
> With the above change, feel free to add:
> 
> Acked-by: Fan Wu <wufan@kernel.org>

Done, thanks, that's a good solution!

