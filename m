Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479C0D1488F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8C56B0005; Wed,  7 Jan 2026 21:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A808D6B0088; Wed,  7 Jan 2026 21:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC626B0092; Wed,  7 Jan 2026 21:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 889FD6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:08:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 321208BD08
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:08:15 +0000 (UTC)
X-FDA: 84307161750.01.8526620
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A409160008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:08:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZWtneze;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767838093; a=rsa-sha256;
	cv=none;
	b=RE05L2zl4S2FGvO/DOFMAxsggUogzPVIc62jvwnHOZIP0c59P/w5v783+1zTiyO+K+FGvQ
	O0M1lXxjquAyKocYpIcze/3g0lMaJ0S3xm5GL73u+PljVgnYdOCfnHr56kRtvjYOZ30IoX
	rhA9KTbcLmrfe88QiNoJqIxOGKogyGk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZWtneze;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767838093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ppb6H5HUGceEyB/3Jt2uCslY/0fkuEfSp5CPRMc3lxo=;
	b=gZmgArTXKQY8sCm06veBlDDlILDWt1Rdy8rv3Zlx9B+IHNJX7lDvI5XN7H1mhod76jHdEJ
	ra/itiYcSpcjyeK/M6wRlzq7EgL1FpeCqDm0CKy8De9ZnhVbn8eRx/dnbj/ejjWIGSoxh3
	5357wLN+YY1gzK/erFHW6d6FaANOGks=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b04fb5c7a7so2196187eec.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 18:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767838092; x=1768442892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ppb6H5HUGceEyB/3Jt2uCslY/0fkuEfSp5CPRMc3lxo=;
        b=eZWtnezeB2JiHQwbdLu8hjoxmVRB3NJb+za2dAXsY799fTWBt9tvoqadZX0hwlOK6+
         in/HsznWW1MkZXTqmENbzEhSylwecoubbQGOySPd299xGcQulYPIoO2XPY78JPVsQ/G+
         mMU/B5glgAyToNP7BFBzD1+Ei6Wfsqy076RmNGPTbtYLna539E7hn8HrfEvD7DOST9dF
         6tGMJAS4DRHtXdaOVUOQcasVvnRLyJD+0Ac0aEAJADhrTCEUAR3zpo4dBm0puawa+jVq
         o+0S6ZqxFqWeHg5/6gRCHAl21DIyafYixB4i/lMQwb15RSOW9J58Z6KDj4qEDAItYN50
         9B3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767838092; x=1768442892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ppb6H5HUGceEyB/3Jt2uCslY/0fkuEfSp5CPRMc3lxo=;
        b=QSkP2011XIbHs3pOo1yLdtJuKRD6FZZsEEjFWbAnCo2InYJhWNv2GQXVMBXNGgHSmW
         haKxzDJC8vX9nzPYi3mR2jR4DHOI0BiwTRe3wK6JfELxPAhUDbFnKtd+ymtdJoHh9sUP
         To7iOrfDvyltYKu+YW/hounzo64OPqo2Q4Ne6ym1whqNrrjBsdHndVdDpopb4/1hNY8f
         TCZIuM6w+shMsKJ373jnI7UYODRTjOJ3Jj4dbPuTo0FwmsdzGm6tn8Z3TEgrNbrhfZSk
         GVTeSf5rZeFsQi8CmzDoM+s5tswRLDe6mQWcwFtDDn4OiObR5MtE4YuX8g3ewKomEp9y
         hUDw==
X-Forwarded-Encrypted: i=1; AJvYcCV08b+BrUkMALlx14uKVHclYBQobHd9y66kgREQsc6UwbcTbHC1OxuhIvzSasnzR0mt5763TsCUNw==@kvack.org
X-Gm-Message-State: AOJu0Yygo2GQhgKBTY5/Ndahqn/5bETk6mcADYQXHEbgzh5nPfmDMMJ5
	lSTJ//Uh1PWSyb7SkY/VDUzYjuldK626e04D/rXI3PvqmbsB6nCt9AGu
X-Gm-Gg: AY/fxX49Cqo4IsgQvqRYyceAA4zzwvCT1OlFyeivK1W7/QXE/Am+MrR65bCCWYiHSpb
	EYyc0wrcqFE9+k5hxAny0jQqE3t1Kr/CoQQ5Q5PCo26yVve2emfn/h5QWz2jLt5KJzL4xHJP1et
	LZMCTnZhTDtinuYCOpbLYTVQV9hSWUZ2yhIb74cXQrVg4p3Us2Weqf22AJPrRlItHftdN3ffCyP
	HyAbjwr6cDmGzzqYRzjvISzRuv9CteVzuKoy95U1/eSfpjpbMiNBDzDXYvf5jnHD+j+P3itH1zy
	uHCyGLVILAMd0om1X7stfftPcP6w1W9ZNAOgJkp2ovlW5XkXmbbheH0Sg8eoUww3x64JrQeSoB9
	kxem+coBEzRrqRQ1Q029CadqBAEugPjbi+xhusHbNvYbfnAnWWWCa3u6wnhN/kSSAsUMYDEAFhi
	G7
X-Google-Smtp-Source: AGHT+IHlwOdGSSFLAoaIUg9si0C3CEIyX1UC57Fv6JP70RLF+X1LeT6zcnZQR2MFyMwhnAPu8ZWCmA==
X-Received: by 2002:a05:693c:3741:b0:2b0:4f34:eed3 with SMTP id 5a478bee46e88-2b17d2f0e21mr3130420eec.27.1767838091880;
        Wed, 07 Jan 2026 18:08:11 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1707b3c44sm9301871eec.28.2026.01.07.18.08.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 18:08:11 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: kevin.brodsky@arm.com
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH v2 7/8] selftests/mm: fix exit code in pagemap_ioctl
Date: Thu,  8 Jan 2026 10:07:57 +0800
Message-ID: <20260108020757.45670-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107164842.3289559-5-kevin.brodsky@arm.com>
References: <20260107164842.3289559-5-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A409160008
X-Rspamd-Server: rspam03
X-Stat-Signature: ijoxdmesfoepbb1daeyoaumx979u5oai
X-Rspam-User: 
X-HE-Tag: 1767838093-164440
X-HE-Meta: U2FsdGVkX1+94x7a5FbHI676V+Pe9X0MTbqQ5IK4q/GRUv6h8wH2HC2mgKrt7WgekWGjNAjp+GV2RgYLswk91cl+tFIjF9Ml0HiG4vFCWnsDknkjenEZzC+hV51x2uM0ZQH8YS5Uxmyt0cLnpsfV2XxV13dYeop+arD7DpZGW+R2uWyRG4dwP2srzZaIagmhfcN2BcCo/GTWO5RaN80T4ZSdsJ5ORv0G+5Cf8KehQVKAxZEOB1mchdr/h7fVmd9y0fwxYqGI/hdwmYgxBCzsft8ntDXVpfujvl6CXYp9c62HTYzeNOBxhC+Q8EfV296/4m9KU5BGtUijpfa1KOFdaESpfao5F0z5+utKR3GLkeAN0lEyce3SFDCM6+hulErMnBJ5JC7RlHJBOGIOuGzAUP1lIRwbv4C5vSWDC0xRZkr09tiWpjWtqtxqRdOhrUp5Tpg0psCMUKl1H7OZTnEzZX75ZjwG+M2IWGxCfJFdFz39273qX2Sd5TTSQkraYhtZUPYyFPgyvCAe7wrAVjJ2iEJys9aikV7rVDklt69c4A8xe3fqS7scesp3pKJBgkj5Jks2qASVe3y6bEHJJNzMG5FNsBZeR+6VN27tD07D1znxkwcTaMHbeT2aYayvelOtjLMWR1YRfsB8jEXmNAWT7n9kchsXmpSGIduqKZvxmVx09S7uxKxbPpfycOQ5spY9qJg4lvUIwPQt/7je2r/czbrVCxeqGhI1BKRIOqcX7N3bknu8sLEMRquDmthgQXG9Fwp1BSShWjJFO6GRX7LuGYwJoKq0CVl7b7YZjdINVrQGjcWuRt9diP3f2eIHlAT/p9xXImqmVOJAiQdClb1JALTK8ankVmf2toC0PWIy+xRuS8eukBfXTVivxRohjTalAH0m+OTM8ux935/fDTAF3/P0tcGwMdv94FFzD7PZ+XXDJru4DEMrWJtpIgY0sKFdpPfXWn7W15rzlxGmswZ
 l6GANIwX
 N68As//eGiI6awFVudQEvkkE3sP+H9B7J5R2ELyfllr7JAoW5ZkInu87CnDgI+S5/mnej2g3sWFFSVC5oUqVl4tJA+akHgZ/35m/O9Gmx8guBaQEb7/fpapPgSne2nJbejZkKUGZBOXAl6q0eMEXqxsOB7USZ7JP6iMVDgjEqDIgjq4REw37XZO7CVHg8tfroh5CTL9m0GRx1IFBL1l82Bl3W2JE5ZMDFp7wxmctx6w73wWlocVyAtvSruGX98blKrUHxggsxN85jyyvyYWgM10AEzKFc2TsfHg7AaDey1mI7LS4ninC6RngSHWvJwWEIf+dlM2bKERQ4x/JOPePsLpWK4d+CZh7Uk85uaYy07sEyx++WnBQy0aR/hnWoM7JNJ+amRw/FyrFmWJN+o03kZ6NOhhaHn6dsEIEbCv9Q2lDdVuL0b1X1dHMf9KoUK+p8o3h+1bq2/LYIMNkLDnh2Aov60mEaxKpH01at2lt1sa3wNpI4I79Z+vXqwXdtraHtGVujQNxC4Kgild0oWwT2GkRJo0djQOWkm7hDcxwx0hCAnBYoeleA2TdhDEAk8iYB4ENa5mKKnsetKbl3+X6Es4CeKEmC2KTJT5Yv9vnACWLbIPvmObJFwnZ0Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.004066, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

