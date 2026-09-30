Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADEDCA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 18:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9396B0088; Wed, 30 Sep 2026 14:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A176B008A; Wed, 30 Sep 2026 14:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E886B008C; Wed, 30 Sep 2026 14:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76F456B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:40:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F41AFC01DF
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:40:39 +0000 (UTC)
X-FDA: 85271294640.17.85FAF55
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf16.hostedemail.com (Postfix) with ESMTP id 283A5180003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:40:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b="HyAdT/rm";
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf16.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790793637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQWLRh3cX6MfBpqZVLbNMuRtWRQ1VYNiu2fQhkvtL34=;
	b=kw5WX1LZIp6Zm9Lb/q9EZHkHvFF4cCjBF57CHnAoe6dVDyCks5b7/ZILoN6NtNUs3aFF+J
	SnZd1Ochjyny5SFPsDOVqzRkHYVOkkN+Jw/LrL/PlUPc338quVs1DqjJmxKJva8iqkGfQI
	iJf5E7X/LqP+QfV5hrCFmCUMGfePa7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b="HyAdT/rm";
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf16.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790793637;
	b=sdQKTlFaoJms3ObTgmQUToP7IN7MEVV+POcgGTcMrxAqBzFZjamUm+1Yc/7jV7JKsoto55
	98LJ3OijoDXjtk77kkLhoyQ+KuLqQu5Ju5BcVom1OV4wDdC+i4EN/PEzSx//lnROznBhpj
	pgqbETsIq0KFlwWdZ6GnZvXQXSuVRuo=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 68UIeRrL3595274
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 30 Sep 2026 20:40:27 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 68UIeRrL3595274
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1790793628;
	bh=UQWLRh3cX6MfBpqZVLbNMuRtWRQ1VYNiu2fQhkvtL34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HyAdT/rmOxoXRyWcabqH9NuxGQOg1f3d3+pRv+UfT0eNMm5SUrw36bNlFLQgKPrP7
	 kJWTBeKnbKn+9izN0S80adjyt1kNPtLbMHrT8XWU76mQZsE1W9MMd9Im7utlYmP9hD
	 x+SCeYCM/vlCdWX03EsostEOH5kGxR/r1PbuKm00=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 68UIeQTt020450
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 30 Sep 2026 20:40:26 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 68UIeNha2112989
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 20:40:25 +0200
Date: Wed, 30 Sep 2026 20:40:23 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arzRBv9ceJsxJppI@gremlin>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Stat-Signature: z93rhjy9n1sezup95nu9mb98846ohw5q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 283A5180003
X-HE-Tag: 1790793636-623875
X-HE-Meta: U2FsdGVkX19YXw56zcf8IzvoyUoHnbPBWGr1PmJijaIOQtaf+B/ZFi0NSdnp9d+SwRHhChQDe+WgAN0V35pewaFqY3Y5nrwge3YyLPuSve2i0oueV2OQUsCbQYc3DtjSViuZ4/S270+cW2PflXFhYMXt8V/uepMTPvZVJ/q/tHJdYlnUJykgbIUSRxmNp279dR+NGtLYag4L9a/j+44HJOrBT4/LlxSUGGCEwMBi+HHhsPd9EkiBamxXpqbCxkymKxWYeD0dtbqiLnqb30nHSS5CQ7kki/UuWDFrE1xkyrndRwqJtLISbhrRZ+gAZz4gIw50u2n3SqXzyg4d2bx1q57i4xWr7IfRcPsmXpjbI7s9ixSMT6AVPbRkt10yPDfNPBV9HckXiXd/4akAZWSQqHjp4uZNExl7TYLQlf8S+9Li2bne1kh4bXfbGAALx34fBymkjBYkHT9Jt2rkcNeS6VG4cnkiid1AaiaUWqTn5vWlY15pizTGWEUD/rVw90MxfVMaSGvNJwFRxlbf/cKbywsviG0w5408fGC9s5GM37J222JNCwmCxmCufH5ABYUr4OBTQ4yLCu0QINrn6Z6BL7kPK6Z6TQ04P1ATIpniZ9X68hPUAlqL4FTxsi7QwfiNufg6vdn0XZGe1JaHdFw6D8F+T9kZ9vSuOiOeRJx/FtbeZ8XuHiMdw+FSKAPmClOgRDQQmO2o3De049zTMnx20irZKsmKQrncApb2mSRZykCWc7Gf0h6++ACUrd9PtmUw51y0j1uIPg+57KgBSFC5y9SLpHzSxncZDl16kujwXKYgaW7JYGrBKTAws5hSyVSkTn1JIxQ2dAiesTViVlDv5Lds0cT/nNDdCdTBqiMZ3PHikAjS+ZzNfoD9BoJDRwHelLCmJvOk3HMmZquIAgU2WuSUJC19jP37Np0VwW3kE/kKZT7ENmSTQgPb0AG6gHU9pTzP0ibXuU6FPMo0e2Q
 BfF7zxHb
 g8rP4Lw2cFt9TF/L7z0Zl7VNg6rOQb+aKdgHubLuCie6kioxx1cH91V/nn2qKXBnSh8Y0DuE1AInnLtfm6GP0/z93aIvI8kyJNEAh/l121597CaszkYNb/WIkOyg4UWqjckWWQpmNef+9Qzl0LYcPn9b13rd6TAr/4gaaGTRzShiMFNIsJCYSc8G0NpLOjwwSebuhAbVefAcLN+0hhIAFvrWX49q/4uPJO+FsCYdSlX21pI0PfLy2kZ075Ya7zEljdSJ6f+LpxlCgUz/PxL8lscu3/+Fkr5MAKTX8w/iCn6jo7N1EXKqBiVZwZ31hAoj7w/lWkH+CetcSykg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(CC Paolo Bonzini)

Hello Lorenzo,

> 
> Yeah 6.18.15 is expected, I'd not say reverting is really worthwhile honestly,
> given what you've observed previously.
yes, I wasn't available at the time he was dealing with that..


> 
> Maybe worth checking if commit 26505e1b5b54 ("KVM: SVM: make svm_flush_tlb_gva
> do a full asid flush if NPT enabled") helps in that case?
sure, I'll do that.. however, the patch doesn't apply cleanly on top of 6.18.54 at
all.. what do you guys recommend, is it OK to adjust the patch to this kernel
(I have to admit I'm able to do that, but without any deep knowledge of the subsystem)
or do you recommend to apply some of the previous patches?

tried going through them, but its ~134 commits affecting svm.c between
v6.18 and 26505e1b5b54

cheers

nik

> 
> --
> Cheers, Lorenzo
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

