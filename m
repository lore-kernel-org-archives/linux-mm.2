Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB12EC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30176B0088; Thu, 24 Sep 2026 07:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9E46B008A; Thu, 24 Sep 2026 07:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9369A6B008C; Thu, 24 Sep 2026 07:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0D26B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:20:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D414FA032F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:20:08 +0000 (UTC)
X-FDA: 85248411696.07.A9F9268
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E67F18000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:20:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L1TmZyqY;
	spf=pass (imf16.hostedemail.com: domain of k.shutemov@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=k.shutemov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790248806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4OaDlxvzX9mKOFy6ILGdRaMRWgslNMIeO55AJwGVgc=;
	b=wzSP023X/5USqxX4s3nkThAwfA9YZK63jrqHCM6DQnqar/Q7Lz0mNlmRHvsv9Vz6158ccj
	2z8YU6MukSfbKxtI7KQdrZtqF5K0F31/zScxCeoIxJOYB5ZZ8uRpcgW4NXgXKrp1YFunw1
	T0z4rIiCG2sT1jsuZ7B1yyyDnd960gs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L1TmZyqY;
	spf=pass (imf16.hostedemail.com: domain of k.shutemov@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=k.shutemov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790248806;
	b=LXDPEsFsIRU2+wHOEhpGdFZmjlga5eNjnHWBdA1RKuQeWoQziCKDMYnjvveYxMiqUnx/1F
	9vJ1QkH/ZClLJfQuj30iDfJkwnPA7E7vroF9bk2Z1XbCZLJlcEumMqfkXJv/bZ4RI+i+gO
	AEPpcCCRO4Ru75tg+agi1VIiiOCuADI=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a9edfc851so284543666b.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790248805; x=1790853605; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:feedback-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=R4OaDlxvzX9mKOFy6ILGdRaMRWgslNMIeO55AJwGVgc=;
        b=L1TmZyqY1f1twAOQi0gxCpJ2akTiOrHh6TsgCjmUM+Op3FlmEwT9jJa3kOsJ6vMjwu
         OYslj79DMRBjgWIY/Eo7jtND/qjuoM027Aa9889bRmXX7VAqnHblwxD7hq6iulA7Zzq+
         jNWzsPTt/oS8a6UPG80ES3GKtl9NAs+h/qPt2VA2WAQWl/43YQQoqSlK+Na4hL4VFRur
         nZi8neuYmMcrxRqk5EwiUiE0Kfsb9QK/dBNZaQoJeNUviOzgtteUspvITRN0JEqBdr7f
         nKSWrpC+fOmNVrISCa98ZHUTYlRjyLnB/d8uccL4SZku8NxlQI7OOA46kTvpgvxwf0RM
         gZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790248805; x=1790853605;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:feedback-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R4OaDlxvzX9mKOFy6ILGdRaMRWgslNMIeO55AJwGVgc=;
        b=jmbB17xH1MXZa+Q0IwFK0VuuuFo1bF7MyPO736o4ZCQx2SXAUZyWed33kFMdWjyueJ
         Yyu0DugrtRG4hKUJXEgFBIpHL4JfPu3H+8a5xzRB6XvsuBEiI3iWf8NShqBkUSBue3Gq
         ugQ5ptb5qY3CmLRYO4X52OR1a8Ahf46XrIVclxk10v8Mq09bquP8JPPdeM412KUe5m1X
         KmKOE1egGe7pqVSisDtMluYaj+/IAJ2ale98GlO/rn89KNR9jLP0n3IzBRUxm7LCVF35
         eVk3SjZ2XX+7mtnm5+0NobE49UQ2/yOzhip0gNKbevKYHlcD0+zNKJnhFKUDneAihrws
         upbg==
X-Forwarded-Encrypted: i=1; AKwUvByQ+1KqTu1fWzXFMlWr1vNi0ad6Q9j2onpv56RI5QwFDLtnKPG2UcSyr4KsTs/ohyLIT+DkpF52GQ==@kvack.org
X-Gm-Message-State: AFuF++nUuJMyB5rrNWWKsfYfWXi2x6wSt7sJ51Ya3qD9stfqM9REETnM
	5NQ67gaa9vpY3nfJknUwFsXMz1wpr1mRbu/kqdt4dVPSk/HDJ11Wro+Y
X-Gm-Gg: AYBFou14jpa73YJj3eaH8sfTAsSff7xVquc2dLyYAialfp9OR53wcB7J4mCeB8nfTWb
	eV/y4FZkU3WX1dZYrtX9yNH57fSU+BgTWwLEcQMAN+koIol7SET9B6Sl2j1KFU5PIW1c6lcgeOh
	8UYg81aIAdPU5BPFuOBy66OYZ6L3a4PwaYwradIPKqmgmdQuAYHly5RdBhCMwZpUftpBgDZFVJJ
	D1ZAaViDiVKWvlLiYILmSj2Tudu+smvF4EP/NhQjSlgMQORGtu8uKKJKp4HSESuXTBaXobHXzC0
	hN7jK2Xdpa0l2vfsxKJsXulSmH3x63WPuk8jbeMD5VrzXdL2ewW1Tes9y4gC4x/8V/fSgyzCpeW
	vekbFyanTxt5JRqBMa94RdsboKpfxKE0y4PTdaBD/pHl+RqRzan5Qnl4+PjxRDO6pEBy/GQoMEJ
	lXkRmKxUTjn8e9ZFyYm5nsdC2VH/24HvWE5AwGJdTOmgouezJOZzTXfgAD0O4XvEWZGP8s3rH/Y
	NoSe4SIDXZkZZ8Nkl3STRGPEhQzKnu6uVTqM9L3eYTh9xnN+5Hhb6zdAARc
X-Received: by 2002:a17:907:c012:b0:c2a:8cd4:cf36 with SMTP id a640c23a62f3a-c2ac22e1662mr167385366b.34.1790248804955;
        Thu, 24 Sep 2026 04:20:04 -0700 (PDT)
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com. [204.75.18.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aae5c7134sm291538866b.17.2026.09.24.04.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 04:20:04 -0700 (PDT)
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8321F198005A;
	Thu, 24 Sep 2026 07:19:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 24 Sep 2026 07:20:03 -0400
X-ME-Sender: <xms:Wwe1aoHxpD2GUkf8jfK2wDtt0h-YqzzKIzL84kUvaXYcnmY4axV3gQ>
    <xme:Wwe1akjHwz3xl_pcnN7Q_UhAVTKXbdV-JsvpRuG6Wh9WJ00tg0nOv6OC8cjSwxIRh
    5DmHftdfy7Gj3dkBgloA9W1y72gCW1GW9iJRRKPEvQYRs6qMF4qfRIj>
X-ME-Received: <xmr:Wwe1alwhKNtlEPc5wdXI1K7uOYNVupMJCVDk7N0aie2Gh_n6e2MAHgyUl70>
X-ME-Proxy-Cause: dmFkZTEemkH/gTllvrJQao9k3oTuIGHSE6fjeYMBPOOM70MmZFQCiNkkP8ox51KasaOxkE
    DfOiKw7u2ML+4aqlaveeC7bi5IIBD/aid3NVfALkLOH3kJBkCrS9Q9ph8TpWitSM/pWIgs
    /nrEjYJnBNJHwBd9H3rrzRz6pXoyoNrVZK9jEhQN3rPEkqkIBpc9HTdVx7InB4jcSUwb3E
    eMkEma2bPyJjaoSCNjsJxFBPIf+Gklhp8Skenca/KokKG3raOClFfElXCDrPqLi2OnglE6
    dWLlbxLMHUwZOKdq4VQME/xn2wS27h0tVwYj6bmYhvImEJh6Mube2HOFRVC3rGVKfhlpm5
    JSkf66ZU+v5jUaunXACswkpeQPmCji+ImeK0FXC79CShfSH1lUvPXqQx5Zq6ZxokRfTSYg
    A6F0BtUUecmOrzA0ZIvUuABGMfUNZs77c8M4hULgsty3v6Jf8932WwqQOB/TPUurF50KP6
    mnSPCkZdHsOdPsCi0+3EsOUSyPV1kMapk3/GTrB1E1dsN4e6oqnujFXcF7ZiFDQtzmXzfJ
    krMC2I2k42EvNYiJs3l0V3armzEAuRfsDdBDSikCQteCX7HF+FpflFwseXJ7dTsBDv1LnJ
    i/acyfpwwGK/Umvpm5mw7APdNzmyChxecTaxO2rD/mQb4fk4jptfjZ72EUGg
X-ME-Proxy: <xmx:XAe1auQRVNiaJHOKpRct0TutvCPVxvcZu6oUvd93SpQpMkg6vr1yig>
    <xmx:XAe1asEs0Zm4GI42ak-uA-yMo4VlMtDhjZptCGgeQUF6L8b9qQ48nA>
    <xmx:XAe1al37l4_t143Yw9EsvBefeKb0kFJjS7KKpPpHnreX76NAhe9TpA>
    <xmx:XAe1an1-ryh40fdYC9XKVzCbGbvV4XAdVH_0Z-GrqI8R2Oqo2Og2ZA>
    <xmx:XAe1apdeOpL5Y--D8eiHeAfEFy8vDSwWlSlmvaJXKkB4f3Wnqhy8IWcU>
Feedback-ID: ifa9e4bbb:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 07:19:54 -0400 (EDT)
Date: Thu, 24 Sep 2026 12:19:53 +0100
From: Kiryl Shutsemau <k.shutemov@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, David Rientjes <rientjes@google.com>,
 	Amit Shah <amit@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 	Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <christoph@gentwo.org>,
 	Dave Hansen <dave.hansen@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, 	Hugh Dickins <hughd@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 	John Hubbard <jhubbard@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>, 	Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, 	Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 	"Rao,
 Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 	Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, 	Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, 	Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, 	William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 	nao.horiguchi@gmail.com, tony.luck@intel.com,
 wangkefeng.wang@huawei.com, 	jane.chu@oracle.com, muchun.song@linux.dev,
 liam@infradead.org, shuah@kernel.org, 	boudewijn@delta-utec.com,
 linux-mm@kvack.org, Breno Leitao <leitao@debian.org>
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
Message-ID: <arUDeFDdSV1xANiU@thinkstation>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
 <arPdnxhX9VHnDx15@thinkstation>
 <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
 <arT9TVHmM3WDjWnk@thinkstation>
 <6c79bc6c-abb7-407d-84cb-c9ab29732646@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c79bc6c-abb7-407d-84cb-c9ab29732646@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E67F18000B
X-Stat-Signature: zqdi1fqn8h6mcq1fgzu53n3p7z6aq73z
X-HE-Tag: 1790248806-744856
X-HE-Meta: U2FsdGVkX18AGnZ77WgHOeQmS5+YVAeMNGxRqBnPIthkrWN4HH302djkT/ZVvctgTotrI8bk09ebAwaKZ9qCfsmz3dOUxBm5Oqt16Tfiq99foNVM35UrdI+gDrNUOu9cZzYxfLlbICu9FaB2g2Rqk4VNpHmI2ZZE4FQ7fJLE7oeXLASom2s9hjukRQ43HEOEbK355n98H4r+knC6oIR1nsW7/DHiXeve7WaE8cafmlEGMorPnCw77W5Jzz2Wk9nH9SWCGX1WSR8sXEG3BFrBEqGZeUTh9piayY5KxTWQL2LR1Y73ZhyKRXlEDcYIkzuW0eEyKgabgF5IKB0coZpBMIqzGB5ZVb0hTo2r8ImxGG2TreLo+RrhZdy3BKk3JkXjiXpBZuu9xjcjh0H0Zak1XowdO6/c30nN254DtSdiNFv/gSCFPiER1Zx7pu2NOrqo19YjaCwueSFuilH7aZcupM+y0Rw7OlC8f2jaQllsRYprigmp+KqpUv9XZQKuk/3cNv3Qo0XbiYhEj0yBtwSY2e0wvuR+h1p/GiEw8s3TbOKtiaRHA9hrDOXG7BsmL5Jtp9VUc8dyQpi4ZrcKpwkXs/W/csS2wOTabCqvViqOcbQRVC3SjpU+LfxZBpdyBw/kWY8RBhwjCodwLYeTZih7p51nWioQQ1ZN4076oP/1ESk70CjGWKxz7zvTWNGElydikDuWGOeBruYBz8BqSF/QurbI5iZgi1IiWviGyqI6B7RWgO56ja3Ger9ff+NVrBn234Sljz+mKWSCGES7Qbm2frZIBm6CeecDVcT++4wUqOz9/MFFf5zWc41jqXY/QM30kt9dGakrCC5j70SqPgzapHf08sNwf6ec61+yJCVQMXr4MJsJ/oOU3Y4vEWpdHhJpfdXpbExAfryc8HbRqPhFEj6dxrsXI9qECZjYznUbc1eriYrCOTwegqsuZ5auuyxsn7bAhwlhlTXU3NloThc
 rk39WzzM
 5BUqMM9mJQcANO32DzWv85XMgVPkWarUtqdV85r/L/AI+tCvU31Inqr2FxxdUEFyoOuWiA1qvs3uf1deRMnN+qnnB7vWS5IegrcbwxdBC/efjKi4ncOG4KFvFrrQvBCjTPJnCgjuHRHBpMKnjfdb1tpb15nmP9d4QS4VYb2RyuWQTtloeWvdbPe6lrUG2EDcQWhwbrut0WfB4eBjIly+WHpX59YTrSzmQIt3LuFcg8bJhAi3nPjtRtrI/oKYvlacZZCHM7ogP9m86TZ64dltDPhx4cL5Wwk3PGlYjum77INWdWFpuBs1mIr8v3IpEgZCfHXq70Ib3cjEML5QDIGT148lgA2vpbze53/XMz1FPBCEddy3KiDHWPx+Jn8gQ0jBeOUHGetXbLExFNIdGTACi15nLrkmM4PPPZzaErh695JN7yRce+EHEzcJ+E7Oy1/u7XBDMaowTyMY9Y/+B4EJC91DABK4e34HW2M83clpEkPsF/eZNWfbpeRjJYCnJion8SZBuBFvg6fpLbuw/EGHanq8sHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:55:10PM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 12:46, Kiryl Shutsemau wrote:
> > On Thu, Sep 24, 2026 at 10:32:29AM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/23/26 16:36, Harry Yoo wrote:
> >>>
> >>> I believe this is what the patchset actually did in v2.
> >>>
> >>> That way we'll have to either
> >>> 1) make any architecture that supports kexec select ARCH_KEEP_MEMBLOCK,
> >>> or 2) make kexec scan the bitmap when allocating the memory.
> >>
> >> My naive design would be:
> >>
> >> 1) Teach memblock early about poisoned memory ranges. Don't let it hand them out.
> > 
> > I suggested using a bitmap because ranges are not scalable. Some memory
> > failure modes generate errors repeated across the physical address space
> > (think of a column failure, for instance). It would produce too many
> > ranges to be viable.
> 
> These are in 2M granularity. Is that a real problem?

2M is arbitrary. We can trade finer granularity for the size of the bitmap.

> > We already consult a bitmap in memblock for unaccepted memory. We *can*
> > do the same for poisoned memory.
> > 
> 
> We can do many things. I don't want it.

What's wrong with it? The last step on allocation from memblock check if
the memory is poisoned in bitmap. If it is, try again next range,
starting from the next non-poisoned address.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

