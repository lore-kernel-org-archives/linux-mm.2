Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B92CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E265D8E001C; Tue,  9 Sep 2025 10:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD738E0003; Tue,  9 Sep 2025 10:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A628E001C; Tue,  9 Sep 2025 10:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFB748E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:45:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95E8911A50B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:45:36 +0000 (UTC)
X-FDA: 83869985472.29.2145BFB
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9373610000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:45:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=CipBISKD;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uZOXLAPyRyHSpVnROAOaZtIMYIq6zL7rLk9iGSlTxI=;
	b=bEHbrbNm0PmxV2axC0dZr6WYPKEkpRnlp61R9CswO9ifIlBCVE0kX+7O50dcPJPxNbHTIO
	MNJFVABMF3kNrWPTVpRAt4F3eyDetQEAgaHIPT1ioB+ttkP7O+pGI0r/65z32A6FzJe1/T
	/hFwe5zjN/J19KLItj/ZL9Bs3bI+D4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429134; a=rsa-sha256;
	cv=none;
	b=53+DTLGi0G8D+OOEBBZ8JTP80muckD/63vt61DegOcvOAOgNnqEH/+lWcj7OpxH7lHZh5/
	J1dotkv4OO9FM9u0Xp2bUuBmSrAkrWwFuCRpgOuTgmS1dM40gOwIIgNeo2j3N30sAZf52Z
	QXABmk547cg9zOKpuqlQ/Hb+PAX13Eg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=CipBISKD;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b60144fc74so31745491cf.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757429134; x=1758033934; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4uZOXLAPyRyHSpVnROAOaZtIMYIq6zL7rLk9iGSlTxI=;
        b=CipBISKDPElQeg/9aqUzF17zmwUKkTaPtg12qfpjYVEjDik2LdIVZ24XvEkiMs6mFw
         80BwzXtJonzvXjvwPtdG16LEDNU8iHcsL7PlPsreZP2MN0HfN6A63o1WbkSR/NukV5lm
         MRR9zzAufTkAwg7ebA2yi9LHmn70DiPrQxvPEAWiF7xCCMn04vVDfhRHLPdDuUXCMUlj
         60gjWcQ4GxBquukmc8/MfYVf6U4n59QzzKSDMnRFsc3Hop8iWE3fM6Hjmwd+hXYoI4Cv
         xm48BhsxatBSrv8sl/Mit2fQ1ODu+KiuhUoqS3isdWE+8jrx9/WQ8r8NwEpqMbYUpEPH
         wcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429134; x=1758033934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uZOXLAPyRyHSpVnROAOaZtIMYIq6zL7rLk9iGSlTxI=;
        b=N2cnMeUCOZiNoQvw5kg3U6Sgeah6eWPeF4ImGNGFOwB8bTLIYMkzqT/r3vqz3XGu+v
         c5MSg/tH24uFagFxoEv4RWgdFPt35AVPZdn4sNapZDchKMwkNx4T9ep4w6YhiGVy6TIA
         zbrF+T53B1cIoSUnaxhlg/k2zbU4HStK9Wq6IDp4x28KKhxLWiw7QNB0Odqg6iGDZrji
         fSFxCqx+KlOvsU7mHLetRJllxDivfOqoipP2xCcRyc9rZfgfFtU24ZQk9I6rywYCMvYw
         Haia5lOB0N087wkFHpY7tSeOPQ+cNcrntoUksCRsArURU8vD5vnzGPFFXkMOT5vzCRey
         q+bw==
X-Forwarded-Encrypted: i=1; AJvYcCV9C0o/gX3vs7NIKbp4xmfDzu2Ia5dydEtnhErWxCzgbFNNCfXf4Q+/DsMsogbfSBquYQluE6yRiw==@kvack.org
X-Gm-Message-State: AOJu0Yy/qWWNaaznDqBCqlb9gALtWJru29e8Tk6iQiAHy9CIZa4zaYxF
	nPOWaOBCFxr6CFXWepJl36YCaZeEP1V04Er+udLodgSYE7xYELnJdSoZpobNlsZHEO8=
X-Gm-Gg: ASbGncsibyodNMpnuFD48YDsLNM6TadskmuOsAjlYgvwnm34gYjDsrJlgZ+sPRYmVbG
	7OEmPG397iJNPUrZoVka8iyaICzFDoOm/bpT7FnU7+OrZwJ9FE3fNbAl5jPi6y/YGzlJK7o+r8b
	rTwsKhj00wrNYnB0+uVra7vtqyPh4aCTnPrVc6LGO/NPwFsPQTFemEBg/xT7jxLOMbRLAMQnTCl
	6GlV1YiPWUJZ9UFbfZC00GuYu+uDfayhjFIVCi/mBOQmvodhKOe6D6meYLSieex1CR0lY5rdWJ9
	e+uuUVfvVLk157cGGb7DgE2lZ9Bm6sMNg1+G52sAvTqUUS6E53VcXbQtvIlx3VpqHTJtmdkTyKg
	7EF6udRXvTw33
X-Google-Smtp-Source: AGHT+IH2Iorq9Vvi2EzyiF/RqM3KF2vUsBDvK3u3vXOIIzu/36bNO/hzenvFXa8ZjihEOUIdu3YOGg==
X-Received: by 2002:ac8:5753:0:b0:4b5:e89d:c78e with SMTP id d75a77b69052e-4b5f859800bmr149376721cf.76.1757429133333;
        Tue, 09 Sep 2025 07:45:33 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::6bec])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b61bbbc302sm9671331cf.26.2025.09.09.07.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 07:45:32 -0700 (PDT)
Date: Tue, 9 Sep 2025 15:45:31 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: cuishiwei <cuishw@inspur.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@redhat.com, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] disable demotion during memory reclamation
Message-ID: <20250909144531.GA1474@cmpxchg.org>
References: <20250909012141.1467-1-cuishw@inspur.com>
 <aL_aA2HKjfmwBaJ-@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL_aA2HKjfmwBaJ-@tiehlicka>
X-Rspamd-Queue-Id: 9373610000A
X-Stat-Signature: yhgmg46ez6h8e1o9wtdi1a85koo913ti
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757429134-931215
X-HE-Meta: U2FsdGVkX1/PMQAOj6bL6JFtG/UzJvbdxtNP8/QPVDgVH1ehho1Rrt7w3kHNxGbyTtegbFMyv0wMxh5jgwQx04JE4SYFpP3k2/9yqby9EdmBf+b6Rdj33Ga+WBMMfL88QflmPqzvULJaqjpf5V1ElJ4ciKOcYgzkNHNzfll4sZ0nKVBeH6Urh1Mi3zHdFz3lvG9tlVut4ZRvpNGB/IkeJwHJHo1fiOOk5smKJjmjQjJFs17HeR0reRnZGWFV/yKimbYdH10m/FCxAZAglu+6GWyS51uDzRborrq6geSwvO06C5DuePigfbxlZOK+GqDnfybrdFHDQN1pkVzrCxZWvXvORzLuG0cUE1Zo9auNPV5sbmbr0YQ02i3vZnT2MDhCL+ykArd+n0Yi8eVlK32AnjvY9pNJpCR1K7U5PMTwqfqKzjqIucJBbG1Bur0cB7Nrz1SuH40ew0xZvv1OrY09KJaq6AJBGWB67gixjdChvnBIDbvZKJvtnAbbAvaCK9FWEFs6ZugJaWsJXt8+QNPF02+LAVkWUydSWLsjE0WHwn+sUnDCMYQvs/MwJ+ML119bIFoFtYzWaLFhHh+oD3qR2ZsqI0AUCyJMfRsRrb4J/7yv4QOMCWSvBudDUVwBGeOnuyuFXPBR2iXczdfoOLXf7WRdeVpIodxwTHqjnrrO158C+Khtj/RbEIVh3fEgjNUtWKlsz6jiEocItzQZASxp4T9ECenCNzZewCy3HwX9GMR8ds2ykoJ/SvWlIbpgy2SCsAURBScuwdIMxEfFNb4vBoItKJV/RNJUqRTGg0WErBVADRjEStBQgREHa9XqlaPVJPhENLOBVIBhvre0R7n+ZrL4JiuIweC52VMx5+ZpuwMi/4I2VvTm1nvosrwrGWIdGLRhnKvVX9QMbTC96w/oFwg+fO6/SCvrkLTG02dml1HBNABgmt4e96awimi7wJicqMlDeBoutKqM4nqiy+s
 wa6r8JpB
 SOeyrH7DFj+c1uI9cfLyVhW5lUVom4g8K89AM+nL2jRU7tXzx6YYLqeuVJk/bVyBUrTFajvkTn3RM1xDBsvlfWwfpUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 09:40:51AM +0200, Michal Hocko wrote:
> On Tue 09-09-25 09:21:41, cuishiwei wrote:
> > When a memory cgroup exceeds its memory limit, the system reclaims
> > its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
> > set to 1, memory on fast memory nodes will also be demoted to slow 
> > memory nodes.
> > 
> > This demotion contradicts the goal of reclaiming cold memory within
> > the memcg.At this point, demoting cold memory from fast to slow nodes
> > is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
> > we should set no_demotion when reclaiming memory in a memcg.
> 
> We have discussed this in the past and it is my recollection that we
> have concluded that demotion is a part of proper aging and therefore it
> should be done during the limit reclaim.

Yes, thanks. This is intentional. Please see 3f1509c57b1b ("Revert
"mm/vmscan: never demote for memcg reclaim"") for more details.

