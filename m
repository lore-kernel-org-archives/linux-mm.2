Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF0BCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 12:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538718E0137; Tue,  4 Nov 2025 07:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FF38E0124; Tue,  4 Nov 2025 07:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4261E8E0137; Tue,  4 Nov 2025 07:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8778E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:50:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C129F88CC9
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:50:09 +0000 (UTC)
X-FDA: 84072907338.18.9318044
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id B86B280004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:50:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CyaiKfC5;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762260608; a=rsa-sha256;
	cv=none;
	b=iL8c38WQp66AdIky6kt6qAqXz5K23qzxgoZWmb4PGezubK2JJ5l1vOl61CIGamFF78B40C
	h1XzwHU/0sCL3A/LlFajg5IfbHalubqc9dlPDy0t7tBI0JagQRJcJEOky3SGRp+pnPmsHr
	idd8rgFwaaTxlQ3wv1GdB7i0kisgTlg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CyaiKfC5;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762260607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSy/9WfWflmiCy1g+Hm1L6oAK5V3Tu0hQGl0UFKoG2U=;
	b=BP5TMofrx7OTCZJ2ePyrEkgZ5VYrJKRfud8INjTTen0uXsjuf/vabjQyXICADqWoCcU3nO
	xtmvpp2F/06+JjU4BJvKR8tshZyvciRAkDy2DTOi4wkEHWDcGolYYW3FDDdCPF12/QOdeU
	0J9bVkdKfHTC7E+KkzvIhGgB3/Gwh48=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee130237a8so3421241f8f.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 04:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762260606; x=1762865406; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TSy/9WfWflmiCy1g+Hm1L6oAK5V3Tu0hQGl0UFKoG2U=;
        b=CyaiKfC53CMBA7yatAEBubzxJWyti7sGeK+1vy6+00ojTEs9XOJPlhCL4mmAA+OADF
         rW/9DDOit0HvJIExHHeohyvSU1oH9ei2TAkGG1tF9sqgyyTYELPIv8hPEnHAi+ORh3aL
         KOWfWwTnM1yRmfn/5bLIytQGzNAKLdgwVuxWVa0OCBdoQd6nyC7zCpbogVkQEkezv0dH
         RsqXiUIOjNxZDLvw9RrCqRpBrpfXsNuPIgGxUp4vrqJGkkcGsFzIW3MeHJAVpQsqfQ7q
         8G3wcIGqKpyKCSFgBRpIvemc/Ex6kjqkppoIvIG3jSkm8TMCA1trWapuf3aP/6ft4gaQ
         +zyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260606; x=1762865406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSy/9WfWflmiCy1g+Hm1L6oAK5V3Tu0hQGl0UFKoG2U=;
        b=WYpTFohWmScS5iRQ0odk17GwuRMdLuPjKUUTIKg004n7DXJZAdCXobuzGb60P98MLl
         SeMuEuF2BEhd1UfBwCJcIbRit6FgQlApGjuVnFpRweX5hiNF945F0N0V9Z742NJ2Ynjv
         pdZaey7uHhQp4ZkadhlAa13QxNFN/IjMIMYFv46uzgXx+G9XtqNtuvhC+LCFd8dMz7uL
         lmy5ILuL/4bPezYdj4XpJNTOpTgjnxiJ2EGzdqgjWBdmyLfCdZw/xOXr42/7D3nds0QL
         V4zJzVkphpsyTruwTgmaVVgl1oCqJSUv9mIs7WV4Tk7V+uNKtbqOQceJvnt6SSKwfley
         bwOg==
X-Forwarded-Encrypted: i=1; AJvYcCWvholz+m4nGjk754aeEivGcUIGbDpJLh6CZhHsVUzNp0cQXfb6XkVR/57ed7seR4tn9qslxn1axA==@kvack.org
X-Gm-Message-State: AOJu0YyKdtuOv8EYZyfa3FZMBlNni/aB1NbpZy14jUXy/wJdwwKXB+YG
	qZirzy6rOAvAv7Aih20sVlnCGvqPqYvcbIGW21dJEtdTEiwitwN1U6npIYYWiap2Osc=
X-Gm-Gg: ASbGnctF9Tb9vAw6OyISuOt9r9OmW8yWISBo2Q/yc7jkk0YwtDajwISaH+O6rUYpNAJ
	YUxO+zi6QbllMlaDmhYiGMbJ3J9US21wh6ND+B5ePkWOCQZQ5Epmi1sK9PCCVEqKktBakhe9Fme
	62Rbz9Me7DdZR3At/I5BO8QctEd7VDcrbMUMBa1jEvitUUE64FRXZw3D9A68oUhRK9f23r7A8UC
	VNLDjJc3Ve+xmn3LHmgvHHvpLTfyvOZu3u8KNiZhzOkQAzLY4CI6H/25CEFI4nClx0/OjhyMJGq
	GReyXfzz2Ekh+tC5NM6n/7c8ef7QvVY0AC8Dw1HiVHVA4pZnWzU4IXPeKn9ocq3Gs8p/2YcbT2U
	Lhvwej/jeSMxQUy5uHy3CRXyTzqdxVYt3ZbpXBSmf1bhGOAKO+ROKDnTkQTnIvciFqMgn7mKqCB
	qyiVjtVt5b
X-Google-Smtp-Source: AGHT+IE2E4BmkScfrRSUYdhsXhQRS97zBin/RS2veu0oLBqU7UvS5Xiyc65N48mfW7uqJ4AZsBge1Q==
X-Received: by 2002:a5d:5d0a:0:b0:429:d742:87f4 with SMTP id ffacd0b85a97d-429d7428a5dmr6103181f8f.11.1762260606047;
        Tue, 04 Nov 2025 04:50:06 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f9cdbsm4467712f8f.34.2025.11.04.04.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:50:05 -0800 (PST)
Date: Tue, 4 Nov 2025 13:50:04 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQn2fIcj9LduzsmI@tiehlicka>
References: <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
 <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
 <aQh1EmVd8IPHK0Gh@tiehlicka>
 <aQnV73KorhS0AWH5@tiehlicka>
 <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B86B280004
X-Stat-Signature: ymkk84h5nq8drdrwh6fp9tmd3ppuqbmp
X-HE-Tag: 1762260607-705068
X-HE-Meta: U2FsdGVkX19MGY9WoH9e08yMtijVb6xHxxbkcO/5kAeVO0Cy7bxMUGsqu2rYE0B0t7mtVwSW0rqSVIWnm0rM/NBjIUmc3HOvo16yHqEXTGLvGSa/q2AP0k67yxn8Q+w5Dd5MWXXs3iUHhCWrz2Lr6jsSZP3lKOtUkOs4/wR3+XhPNDN0ZO/2SV5HBYOxfV9W6U9XWE4SEUyK6eGUVqEjHe7vUPGAJteIs1Ed1SP29oaF4/CJIffoKuJaWEyeEuJtddlRwWoXKJJmMqu1a07S/P65IYo/Zh4Qw0ufqEn8XunAQJQ4yzPi6pSLa93/EZ7uLtfNcuJIRXSxMZPQNu3IhuAl0FWhjfodjZSQyRaF9+h5wx0B0J4VSyu1iRhNGcWsfLZUc9X4/fZoZWw1ypABHdvSYZrGVFiqwdh2FvbOaXsFW5zrWjk1BrposczdHIlScjZMujmijEnNSKEMQ0wC4E+njySO6T1Ue6jjHYxjO3xhxhzaFR45pxPUB965puFv5kEk9yQBl/F+PCtbwr0xoWMFQmpnoh61tmQ+8xTmFgCYIE9ICsZhcALht4gm3LtvituP8OuUL0TCKYyi2IILR2k80WP9YBlKsf2sK4Jmb1gvM1JxNN8RNg4/68WCcdHqIvxkstnxaujqtW621C5sJPSAtTplVP3JWJu/RFsCQ1VHkkGxPB/XmPU57ClQGtDJnJXLnrTHXqywu1e46tPHkV4DxZzCSYDbDOXqOVv3bozg8xMPvpMiLn1v/3oqlM5P9YZRsj9ndSj+LxbZY9Rb6obA34Ly5kMROhDLKDaUs1FF8HwTF6rrsKQNch53dlAtcekYGIDeyQ4pPY7mwV+iJMxHpDChUrToPDznF25f81dpkeN2vfVd4EEoUmD4P58PDJKmgezQy4moa8T58mLiTWKsVkYC15375clokom8srRBWfjwAp/BZqSZMxnkZ0ROKfKjmhkzdkXi4Wur7hM
 /i1PSbGP
 fgAlUBH5qffyuWqIo1BcZVKmAq0f1VpG4yvQwlAAtt7UWOJCCKsumcOjDGBqj0O3DF9U77yXZqIuTUicMPz0US07NV4dt6tLPdyF6oaxcAriZVx/upw+bZMAwclqXOLkHtSM4cBDL5hkIf92ViV98eqbUNzvJivFnJOvL8IksDYTZLjmef4iQo4mak1KK+ana9xThNToWL+JGkhHjnU9VbFrxf60grUaQlymQ2h5vVyBIdOiSXwEjrwfY6wA1Ytu5EbuZvtr9JX8uVW5l0jBRxoc076mtKiE1t17PONQwrOmHqDA4aa3Jb5ByVHDTH/5Clohsr5SLTPCLqUcTvUlxnl4CnD60EbxMSg6CkKZlJ+VxgJsJmgGMJDnN4F1oIuqFxY4KRRL+VLN88T+7f5JfXtaAVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-11-25 13:32:52, Vlastimil Babka wrote:
> On 11/4/25 11:31 AM, Michal Hocko wrote:
> > On Mon 03-11-25 10:25:40, Michal Hocko wrote:
> >> On Mon 03-11-25 10:01:54, Vlastimil Babka wrote:
> >>> Maybe we could keep the warning for >=PMD_ORDER as that would still mean
> >>> someone made an error?
> >>
> >> I am not sure TBH. For those large requests (anything that is costly
> >> order) it is essentially a loop around allocator inside the allocator.
> >> I would be really much more worried about order-3 which still triggers
> >> the oom killer and could kill half of the system without much progress.
> >> For oder-2 you at least have task_struct which spans 2 pages but I do
> >> not think we have any guaranteed order-3 page for each task to guarantee
> >> anything when killing those.
> > 
> > Essentially something like this
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..2df477d97cee 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -1142,6 +1142,14 @@ bool out_of_memory(struct oom_control *oc)
> >  	if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
> >  		return true;
> >  
> > +	/*
> > +	 * unlike for other !costly requests killing a task is not
> > +	 * really guaranteed to free any order-3 pages. Warn about
> > +	 * that to see whether that happens often enough to special
> > +	 * case.
> > +	 */
> > +	WARN_ON(oc->order == 3 && (oc->gfp_mask & __GFP_NOFAIL));
> 
> OK, it might not create an order-3 page immediately. But I'd expect it
> allows compaction to make progress thanks to making more free memory
> available? We do retry reclaim/compaction after OOM killing one process,
> and don't just kill until we succeed allocating, right?

Yes we do go through the reclaim/compaction cycle. Do you think this
warning is overzealous? Th idea is that a flood of OOMs could be easier
to pin point with this in place. It doesn't have to be full WARN_ON,
maybe pr_warn would be sufficient as the backtrace is usually printed 
in the oom report.
-- 
Michal Hocko
SUSE Labs

