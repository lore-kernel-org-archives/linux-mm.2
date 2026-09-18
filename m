Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C136FC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11B56B008C; Fri, 18 Sep 2026 09:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9D16B009D; Fri, 18 Sep 2026 09:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF576B00A2; Fri, 18 Sep 2026 09:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA086B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:28:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 218EA1C2CBB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:28:21 +0000 (UTC)
X-FDA: 85226962002.12.5AEE934
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4076940008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:28:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mF40x6oY;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789738099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIvzoRp4EqaaXbBaAXZ0LdKRD2UHE9DJZN9NC6iw0vU=;
	b=QFBD+i6KC4B5rv+UKk3xMnI/dYACAb7p8WQECT9zslrDz5Ys/2+/Mzwh8l40iqXyoyxuTk
	QIJ7Zo+uQfF36tgXqwhJpmfVYr3IKYaJZ/pMBgETM2LvCVJeN1qd+7cJ8A1Rj+YahEaFPg
	QPnE8m80+nHJMf6BS4+QZeMcHoDaKms=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mF40x6oY;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789738099;
	b=FhQvG2u4fIINclQYDYplLSiG0QBaWnKHEbxcP4A4koNuhFe64OJocWJU3mj1KIwBiHNQZJ
	qcJEoP2SFXoo3BzsQU2Nc9up1TUSo3mxVWDYL4irJr777PtKN7a+Bb/1/l+1cg5DlEYQ3X
	CTfZMbI9d9hCC5ma+OI0gMmLsDOFxq8=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3931so5514705e9.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789738098; x=1790342898; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zIvzoRp4EqaaXbBaAXZ0LdKRD2UHE9DJZN9NC6iw0vU=;
        b=mF40x6oYprjWByoMjMAY8JiHY9D/liBql2n422eYsUDQ0qxIFyHoqkICRYuqFDiC1G
         Z4i/2ppOu+kzy+E/6B9+Adu3I3N2JPJ1tdjWLgJO2HacBcmQCSY90wvJ0ZOm4wvLAuz+
         HwN414ZF/+XEVNLsRixinNgZS3nA1vJpWc6pywcmEs682JCXMoCKMwwTYRmu63J4JDAF
         RMDzuhnRmPFhMCmQO2DzLsnYxV+KMW/UWtH6aK2tRGyxPEWsQhKnmdErEjAha0+N/FTM
         jgzoUP/TpOmIepdi+gvsodzM34M7vxR2kZHS6VLGhT8q94+gX5kHMZBVdGTo6RbazJ88
         wmMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789738098; x=1790342898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zIvzoRp4EqaaXbBaAXZ0LdKRD2UHE9DJZN9NC6iw0vU=;
        b=VDV05pgnBwjR9+ttoI9pC1viBLqS6AHxOln7tSNBvGges97mLsUANCsYwAnCAVXXCH
         +NQSUYD+4FYtGSv50P48/EXV+y7h0efKqd7ow7ge9d04N2Udq6Z5zRm/vKjmihnnaLGC
         iifp4ITA/BK86/CwNqGSbhUerq2IqxFvE6qW3XpsNeokKTF5/erVu3ZK6f67JZFASj6v
         8sScFgEQZzdCSDVs2YsZ2cJQSO019mni2ZYQ//B898TnJ0ckV9lWJV5MHAfEgcyFTrs1
         2/6HDgljpO3Efoxo+/3nZ6C/vLJqhJxWZoyiQ7YYbWgpoOdlDpyA6jC+tckjgEu1Ei83
         myFQ==
X-Forwarded-Encrypted: i=1; AKwUvByO1+vDlDERAZWgyVgHU/+iSC/zsCNCIrDq/v9GICK/VjvXDfkp2dXDw2Hp+jrx+YZOJ3I0/emUbw==@kvack.org
X-Gm-Message-State: AFuF++kjmLKJnycAvBq9n0zC88aLl/9O8VvFsD387Pm6eukCxZCypILQ
	rAyEsV9p8oMJVuTWCeX+iqApWWQWf7eupRmo+ZA0JmHrshGjf6MBpHWZ
X-Gm-Gg: AYBFou0whIRT8Hwow1Ns7OISNjfmcnZS3Kw2SdYGX7z83v6RaR5B8jFpFuF5Mpt2pbd
	1LnMYiF4u97QESyF+ew6sFfLnFhW/A2yic/5+COTquz1hhX3qld/vcAKR6qBGOjCKhOc3HA3Aho
	zj1CKHYwmTbPlqon6Y0Y243e9y0iduotXmHNFR21bkuJr3VMBMFu6PPxnwrXaGaMPmVS3Vw3ONG
	OuHymgYJm8wCMYpaBPsnVPpfQQWBIIWJn5lveUihfuRz3BbX07S2fTkSYvI57R1QiyapkQnd3uS
	JfAZC5MhD8rqlqXHWjNxSVb4BM+5WfyeSfgXyVFxZHVhngRCgGShHBxjlJAeRtn4itBlHHaj5jR
	rM+QnD6f6cqgBZUFSwIr2/nw0+naY6GoFTshyRYi+c9XoHkMIsLwv3uoqeT9qGRQ0+o1X15LC9j
	HibKvGBrqtXkz1bwfQARywHjgFTzy6iJzB4U7ZZj0RQR3cZLZDfusQSHP8LYA/NkpAJVhd2qtnx
	37ejxckCa0ep2/Zpg+OpiRtSw==
X-Received: by 2002:a05:600c:1f8f:b0:49e:8354:26fb with SMTP id 5b1f17b1804b1-49fc574c729mr35408655e9.32.1789738097326;
        Fri, 18 Sep 2026 06:28:17 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc58a1176sm40807795e9.2.2026.09.18.06.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:28:16 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v8 1/5] mm: Add copy_remote_mm_str()
Date: Fri, 18 Sep 2026 16:27:54 +0300
Message-ID: <20260918132754.43435-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0b276f0a-39b7-46ae-b72f-6ba92f65380f@kernel.org>
References: <0b276f0a-39b7-46ae-b72f-6ba92f65380f@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4076940008
X-Stat-Signature: x1kj4k4ggnnm3se8miq35zz5oikt67kb
X-Rspam-User: 
X-HE-Tag: 1789738099-155728
X-HE-Meta: U2FsdGVkX1/DOH2VwuuiBT7l1YGFK5FAdpXA3aII7lwHb+E6fbMAApMq3sKANLItkwsogDfo6CbAww/dhdXYFShfz6Ucw7jut2nsZu7aiwFBxTwlsjGQ4nkmFtEC07M1OTVMT/8rdH+wmnQE63G/KXO+9VFl8Mzo8xA78X/GLx4dndjp3Oum57u+OY7P2LOIrUBBvb9azMr23PC0Sp52drr+KLuJreLlLwlJnKmQAif2LIaC2sMYK+n64ThuRmbM1T0j3VfT6vrXDf0idZf16gUa8FTs9BcayCErN67S6EvvrrJEL5pbkJwAqPEnoh+wVDJyRH/+QiuN21SH99jCbrP6bMODf8PEkOuSaxjaPyIpopxDpFAo7txVcKJhazt+7bm/8jFGnloRO8DPD9jCvNndTaxFbEl+RgjVfVl03PO7blgXNHTFdNjFYKxLMyFAqsXzgcvP6MQ0tkxbobSNc/acglbYQsgVG6MulIuE6E5dOeloRBZdI0uyQNkb36vYrL1j/wiOaxjkLWTw9yYhs1j9pf6QFGyruAxzwNqEDJphSusY4w6ZAxRHcvWlxW+g5f+ZkS9kpu6HsRxIRt5dVFud+cYbqghudRFE7ARq9hULsZfRTDb/tA+JlOwGf8M9ex+DKwFh1IU2o9ogiUDWZOfjrrHbIyCGnc9jaCNXmGje/6pe+EDH914E6iOlKZkiYwl+bKL6sVAwbdQsdP1zrQ0NOPr8tV/WiDS1WJ0aNrEdFxJasMjWYJRPPc0xj9kg4hhGk/p4KpkVC+46khFwir+xVzY1qCXfM99pcadQWHMDTHfOiP3hZRaphpA76308/0LrSbzEMySV9kHhuTmFhDZjGMps5BRHkvYJqak35GYD5XtB3T+5GOOOCzLruvUMNdaBZNd6Sq2lUmR4bl0MpALYlO4rAf5IZzM2YDaZOPttUeh9mQnC/dMR9ZfLQ90btlkonvYMWWWGpHRqvpR
 /646DDc5
 QP05UevBJzAVZbg5S9Vs+kPruEi34KGSmqbaWSfriJj1pN1L3tcPjzG6/n572cWjozMBrzTtpr3CbpR78PuCjJhGBNAu5cIPZr7SwRSeQV3cGlNH+D1kwIEr5TtkGnEgkeRMlD3xNFgPH0wFWZZ4zceCYSfNsh/ZdwRENi8+U31VfIHttNPKNUu9N+GY3RfTWZkYfbIFVCYFE+hvbRavJIP29jXsMC3FDOzeJX641ng78STeoUFUz8L405iTSKEbVnig7QrhXZO48zlYVTPzGRvt5Dl+AhY+0dphQM4ll0dtRuAI4khB5LOsSShoDtUZLXGAinTWiXRL9A/wlIKuny1djw6gd0m0RnOdHg6BT7XVJLnkOGfcffbSQR7sK4zPfF/wFP+6QfcV6LWCOEQjawrp4Q7XyWftN4tt2+MNrqaDlKwbCZFDr9mzIj0waNCTregJIY/vhtrEO2rS5N61jBplGNTreXcs4gDOj++MumRpEU6JY3qpGtlTp46iN0UB0+f9v3wnHfA9rp5l14HGaBZFBlBP0ohkFNi4mlBbnL0zEJ8usA5VhwBBTtaXupJCUpwdiqeX53qx2vycLImUSSUgGeEQF+cc6vX1ozaFZNIXFPsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Two tabs please. (I thought I commented on that already)

Sorry, I have missed some cases. It shoud be good now in v9 [1].

[1] https://lore.kernel.org/bpf/20260918131757.42802-1-tasos.papagiannnis@gmail.com/

