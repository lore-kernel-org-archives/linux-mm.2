Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD68606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=GGBKfwJ1
Received: by kanga.kvack.org (Postfix)
	id E56656B05C3; Mon, 23 Nov 2026 21:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E070E6B05C5; Mon, 23 Nov 2026 21:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D676B05C6; Mon, 23 Nov 2026 21:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A41766B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:34:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E5BFA87A9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:34:40 +0000 (UTC)
X-FDA: 85468444320.20.25ABBCE
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66B6FC0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:34:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=GGBKfwJ1;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf10.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795487678;
	b=xTpR0ra3Yy0W7l7WTw5XB1a8BDbzCbI2obUT4kA9kpCSVwsR6Js03avmZ6Zgt78h/SN7dP
	xGu78nbfVPwFXxgt4DSHwG2bvZKQ05lqW90vMLMVqGCvY49BscqSD6RWTO4keoYnsJsgPa
	vakfP3HYgwUKrdkEPbLR7RnuJmG4Tzc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795487678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDSJtqkuWTb7jjV+6GtDkG38BVcoc48PFTSPKenEMac=;
	b=cCX8HKyvusALZAewz072Mw8j1kmpB9cHJql6xC6q5Dj0CjpAewiS1/50EOzhnRCsFBGSeE
	3xHu9YIgq63yJG6Z5VRPOMika+hifJQCjbiiKoxXgztUKMtO1pQNWPcr/UbG5VemoASc4E
	QmGuGiH156wcz7q3W1KoCuTwNUFJ8AU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=GGBKfwJ1;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf10.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=GGBKfwJ1lmS1+Hvdq9v6tApYxAHnlXiIaAhNuTN5iew8jxkAa/LO9tU7+H5OxxrxTyDFn+BlxkBmY
	 xAprAIwQTYFiSv7pD/4kzx56RQoxwLQKNkY+KYuEVDCLpKSTmNTArpfREud7115Np3K0Y6nH+SP/iV
	 P0QuBeizPJcfFGeY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36b04f7b7437-0e623;
	Tue, 24 Nov 2026 10:34:32 +0800 (CST)
X-RM-TRANSID:2ee36b04f7b7437-0e623
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[124.156.110.139])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66b04f7b7e63-0ff79;
	Tue, 24 Nov 2026 10:34:32 +0800 (CST)
X-RM-TRANSID:2ee66b04f7b7e63-0ff79
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: Re: + mm-gup-add-file_is_memfd_compatible-helper.patch added to mm-new branch
Date: Tue, 24 Nov 2026 10:34:31 +0800
Message-ID: <20261124103431.427705-1-xujiahao@cmss.chinamobile.com>
In-Reply-To: <20261124013855.98B111F000C4@smtp.kernel.org>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com> <20261124013855.98B111F000C4@smtp.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 66B6FC0007
X-Stat-Signature: hoojtmtc6d1e9rqq15e91tesb6w9rusq
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795487675-336051
X-HE-Meta: U2FsdGVkX18N5KkYlQa4btl9rhN06w+TNIq/giPgMZLBcTP4c5px2f5XDedRQ7FmqraS3lqzrq9doZ4Qzrrlnfwube7oaUddCK52XR4ZPYU/nLRzZju58NqnrQl6AgP5Jjh5314JE57zsr87b8/dHE4xPHv+dI4vjReGP/vWzCOLTN8BHePCISRtfD47RA5m+L0C/fVv+N3h6a/5D+XzrONyjL1VCkR18mErYdWtjnkqBscto/5K/p1guBx+9YNh9SLWT9Zo/oo29d09EV1ucF2NX9dtUVt6PXhBs976NJ3eztlRHHSUY1Wd46tItf8qpEBe8vDDVPxx45WbIwNp1Fci0zGMxm3/xak2wq5DkYGchDmzYKxw2lR5rs+dimblZeiHJlbRiufc2yVsTnGZcaMxex/Bl74cV+12O9yiytqe5c0L5D6IYP+k4rT+n+tZyGt+2cDAZqiGZlcyfQjvHSWV5Qf1YNJN1XGB9R15sekXsm9lT9/84fSPv1lfZEnizKuV5foTwklf2vM6Lt8Sa6G8HppU37thusGvqaiwLPbEQQMru1ZAzH1DMzZ4NowWEeZZtBiMDn5gDtjzYhMC5qcSnQ4Uj5gqy/Kl85D987mhCqEE45rOFe2oIEyPQdGyjyENSr6PxQMXFuRJK2PxWmv7EyTf4hfodrBszL8ZhmC656QMZywJPvDhUs80X+cTON8mG0GWsSVc7VqROhRor+XY3YzNQDADxMfMQK9ewWNH90L3dd4SrAB6SCdTInGhfWNXNcSpMherKy6SM4kB55bA/J6wsmMUiMGoain8zeoqQpgmXqZVjqKRfFBtYubQbM8BdanqjLZprGfcJutJ4TofRZ08deAK1c53+jrsQehaP8F3j97ygUXYNn0vNY9ZpWn3DpD7UKyX9nK0y28Fs0XA5IQ8+w5VsQTCBmD5lfu0AHVCdg3q+1+OHo/hdxJGijW1rcCmL9yoAKI+k+N
 cbP6Am7B
 ppiIdRuXVibEqAPrKjlau/mcOECHy5NUE5MpEKOS6X0ZzrY480Pjen/NnEUyYg+oLMNwcmiwg/Y6h4//Kay4kyKydYCaf0KDFoV8jRQYEmv+/XVyXYT4eHX9sWGJsrUxd79PJCAfNbJZtI0HJda6SgdTSEePrbZ/t6nKH8LkB2dndPsF/PxXH8THfyl069UBOmrJ+AsDoJaPcf8RnCcYpm9dQ+VuM6R3N0RyZype2XojEriY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Both patches of this series are already queued in Jason's iommufd tree:

  94494921b628 mm/gup: add file_is_memfd_compatible() helper
  5b370585dc72 iommufd: only hold references to files memfd_pin_folios() can pin

in git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git for-next,
committed 2026-11-20, with David's Acked-by and Samiullah's Reviewed-by.  The
code added by the two patches in mm-new is identical to what I posted.

I am only flagging it so the series does not end up applied twice - please keep
or drop it in mm-new as you and Jason prefer.  If it is dropped there the fix
still reaches mainline through the iommufd tree, since Jason took both patches
to keep his tree building (patch 2 needs the helper from patch 1).

Thanks,
Jiahao Xu



