Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CA0606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FykKSO4D
Received: by kanga.kvack.org (Postfix)
	id CD0BC6B05D5; Fri, 27 Nov 2026 04:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7A86B05D7; Fri, 27 Nov 2026 04:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2A66B05D8; Fri, 27 Nov 2026 04:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99EB66B05D5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:26:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 161D9A74BC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:26:41 +0000 (UTC)
X-FDA: 85480369002.03.3CEF740
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 11B1E1C0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:26:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FykKSO4D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795771599;
	b=qCSfmLFir6RuZB+Yt17MvpdMHIUJJ5rVR7Ho+OjbxEqQb2V6eDqIBdYj6ntJpEkL2hUS/l
	tliZzsuqeK9sGSkzgXJ22xA1IQSa4qXNXlVBDyY5aaeezNpFe1theRyri8mYETfl6cUpvs
	XOzi4fWWN5VW3IrwEco+JUF4kukeVn0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795771599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
	b=lMm2e9mN9rzqlJ0A1eoIV66kVOM32516hKr1d7aCwCb315cRXF8FOZR/q7CdYQzjw4KRR1
	vix4LbU2A5zqWmuRx2KtLNlMIP3vsrGwvl5soh/LbICKLu+m8suDlKs8i98/UZaElCqr7K
	kdzgkdjeoyuZcFZHSsC2ojCB1tXfeak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FykKSO4D;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb606491faso41516805e9.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795771598; x=1796376398; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
        b=FykKSO4D68nMRw1MJjaauAMsPHraO62GbzsTUG+uqQizzWMDB7lk9UYbwlWdw0pBt3
         EliaR49TEfrI/DP4lhNMlAxWDsvCt/MZ/Tbp8MJnYq5RS2I19Ir75nHeogg8SsTyxsr0
         zxgrYCoT/hwPz7+Bd48bptW2GTYkBPGmAQQyh3HfqIuoM03Qh3ESpxGpjW+M5hJaSyh2
         bt4FpdAT7wOzoW/O6QHLyCLMnVVx2Kbp6UsBiCeO/iUfGqUmPS5vJhJ2QjX8a0URucus
         trO6UHiuRvbrB54j6gyTpLH0yG9HueUNQZysBTk2+zKfGWI2knh0K126sFsGu9C1KSiB
         IhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795771598; x=1796376398;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoxVon0gybDyq4RET65wbSko4AYZRSn5g8mIkbvH3EY=;
        b=b2mbY4nTbg/pkNJ9OMysrOUyIgRTi9J5VPM/QTihmbHN5DwMfPUVvAKC2SwE41NfCk
         kWFRzQypcK8LVTavNmvQNywfvJmyZJVg0pGt/VBGCINM5p2wLXnOZHy7YXw+h9K5NmPj
         w2nCsk3fttovRZLKmG/Ds3osG/IoObgaUvL7/nKb2JffxaaZq0aMxgIOlukY21dW/UCO
         HIKQ6VyyggcJctYkBuZ0bWa4tTgNroUZR+GdpDcrfpAmOQXE20CW0oZ9jUIyI+dfAB+I
         Qbwf08ayk6DTJpawwLFyVUrIZTZ2baauqOmV8vyhdfVeOuBqYdNV5CbTJwx19BUrcQ6P
         CzQg==
X-Forwarded-Encrypted: i=1; AL+hErFk0InqLWjTDs+pA+DqQEcMf8hRP9Xnnckvsr/mC30UTqvxK8uFuihrpsqvw86PstfH0FtUI3zLiA==@kvack.org
X-Gm-Message-State: APuU4Z+zr2hlCRkZW1PEtYEU57enuHd/+iAkopO39NzBe5NNLuuk9Adz
	SP4JtyOkhJq08WAHdyDO4rPshfy/Ebo1R70c16Gmb4uOAzjkWG7e1Si83YhWNxZHPDc=
X-Gm-Gg: AZFdTZcz7eoZa6K4pWE94UhRkugXakMDFTLNALfoA+VXh3L/b4Rr/4qM4bJZnYDQzIM
	Z4z4+pHJ3hJmWceHFRLuXxNwLURLbV7lNxziq9Q7e0ZsNBqfEHOYQFldpOePUtXV/Y+77wqnZa1
	wEm2IAWmk+YlzkEZybBFt45nNfo4WnJeGosrLAONI7kM/PltLmFr0/ngEQL0ciJeuTzB6MpOYs0
	9AdliQv5Rt+oaJHxtaL3nnlfnoyrvs/gczGNOj4mvV+mpskas8WVJEljbjHTAaK9xB70ofM5LpR
	01+yqVAxRh9SkZmZV2zx9WiYGKeBu7tlObfJp+JDvSqR74QmqvFuq939+CrVSF8yvsfDE3uyMRk
	PLrAOmO0vGfeThzBz81zzv/dda0barPyXhzr9S7XZfbX2faaWFReCvCJlC5B/6daeNTWV/1DwFV
	XXV1V0v8dQlHgtKGWWlgayx4HgNQvuCmpar91tMtj2pXQYla+LYC5JAUwy4AUC9lS1m5vpPr4F9
	2C0RCPCxlOp1kW9jyJINtBGls/+sudqyxDHUHptP/EQyEU8uDXY3tnFTWU9OKEpIbx2Ohb/7lJK
	XmK93tzmup0U6ibkDco5FyDoQDl615GEl+pXBfI7
X-Received: by 2002:a05:600c:3ba5:b0:4b0:a307:46f8 with SMTP id 5b1f17b1804b1-4bb8880f29bmr537393335e9.10.1795771597616;
        Fri, 27 Nov 2026 01:26:37 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm44430440f8f.6.2026.11.27.01.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:26:37 -0800 (PST)
Date: Fri, 27 Nov 2026 10:26:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>,
	Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <awlMzHMo6_Vj7gmq@tiehlicka>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
 <f188775aea9580f9ab2b477788503434@kernel.org>
 <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
X-Stat-Signature: 9c4geq9ioia7aazkoopmtt98i47kxzc6
X-Rspamd-Queue-Id: 11B1E1C0004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795771598-951421
X-HE-Meta: U2FsdGVkX1+VJKHqH2xjtUIL/DmhOSf12doKHRr5iBYdnAJN5PPTIU5tohCRBh5pZWBmS/6blEOovT561owSPOHusDM9SNRpHnUUPIU2rigWu9BaTVeXEJuX32ORdmkxMUM+fJlA0bJiqOBLWFkIoeqksdkt+VGb6hTAZT8V9a/+vT2uElBHWvhLbt8wuUP6G2rbxT7Vq1MnFtNCxMHBEeodn2j4MfA/Z0nkBN1+rFl4wp2RtA+lUayycqDeemk9HhzQE+dhN4cla5lpZ1u432Y6HQ3EqJKrCzJ0v8ev0RjlQucNBZrYQn4faLFAh6LbIrJfN1gJz7qowmBTutY3WcIj2ajH0L9OdNrPWrtJlitqTQ/au0tmH8vUJKu6SczUkT7WO0WXWbO7P43puNdpoF9oLWLUQqSgk1PttD0XYrsHBIUbcS1haxEcEre/6h0KI99mNkjDZel98MLuWgZhnOk37w8hMhjR6Q0llDrAc3PGIcFNPKyZE5ttqt3lKp0hPqVb2oHBGLguPbZyPNplIpXxsm5qH52jemQPIPNAXnhdHS9KEc7YePsxUUJ7rWuwH1y1FsHTmuye4DXqKaoPxs2l51r3gYl+zzs+KQgXHI9McdPQ/AgzgBOx7PkGSucS63m96ElvHR1l6x+rb0tBskAmDmqsERYHFN5HqiIGLhAzCep4kbv3kURu+33VWjb1cnHhu6Oa7vyNp42voQijL6kCimAFvPBDkfqpJJuSRUBdDJYVngR2Y8Jww8Z73WympS6s7XEGbVOR2paZ9NjMBhePosJiaXWq9+LOW+e8KKC9/2kFFttxqN6mbx0lsmSKpck+cMAZA0f6KsDTwLzAUYri6md4Ec6igjEA2zmdo4B9hm5/ZwW6wBCPjj+mu0+dsO5rJl05IbidHj27p7gEXgOsbYSjpgIxLnRr2lkGQO1wuIXFI5v08R1iXBEPo44KtF+mnB52NF1qa0nMb6E
 5GD/JlcN
 kJY3E7vo7EKjeTzLZnocGBYcLTUXanGM0plOCYUncLtAe0mv1RfMOoXfDzEzLkSP9cv9o0SzHVBN8wJwQmOJ136l34pezgnPka29GKTfCAhkflSL6cULYIFtNiqXKIftIp4x1dinsaACW/mf6W7htDF9REirHGVZElY83N7eSZTK5HRylikx55YSf14OrRlNoa7VdcXOm5WKPGQVN+0j8h5OhBi88aqR2oS40Ftf+Utn5iFKDLLRJJsFxi41eFzzvs+jRMKz23J+hitM/aI1+t2ToxlO1KgF3XBUP4g/vn0okGnuXxDvklfhHlFHvm1mhiWd70xu8p6YCHzSnh9PF0cUPq06Jsx+yRA7V9BtMQmC1F59Y6D6tyO2fGz8Ky2M4OCC6mdERlls+PMKshFMi8q5mU6E7lEoY1PvhFKUMvYQtgb6jn+jfBGYByFBdiS11vePUiFLZYy+aXdt19XJa/XNIIAgpYHOZuMQqufY8J+fWkCHgjSbg28KlECAk6ZLj5j5VYkKawMU9wX76LC/cZlnWteTvIvxj+inPd5kjoBjn/rBL/P8vsQEeWkABfDckD0MKGB3F+endaDzqhqzFT0UugdoTckH0T6gknCE1T2bvixoP7MHZuUSrtsHLeS2tqsGUwYVN835ThoqSPyDK0WXj7bUynQlTec73sUekeNwZIik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 26-11-26 18:02:28, Andrew Morton wrote:
> On Thu, 26 Nov 2026 02:17:38 -1000 Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello, Andrew.
> > 
> > Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
> > target", applies on top of this patch and tests fine here.
> 
> Cool, thanks.  I'd forgotten about that ;) It was a hastily slop-coded
> "maybe you'd like to include something like this in your patch" thing.
> 
> Can people please take a look and suggest whether it should be a
> standalone patch, or just fold it into this patch, "mm/vmscan: Fix
> legacy memcg reclaim deadlock against filesystem freeze"?

standalone patch. And quite honestly I am not convinced we need this.
Let's see what other memcg maintainers think but I would keep the global
thing as this is a global situation.

-- 
Michal Hocko
SUSE Labs

