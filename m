Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38211CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B27F8E0008; Tue, 16 Sep 2025 17:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A898E0001; Tue, 16 Sep 2025 17:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0088E0008; Tue, 16 Sep 2025 17:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDE68E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:45:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA374118BCC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:45:41 +0000 (UTC)
X-FDA: 83896445682.30.6F1D06C
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id F392B100009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:45:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=U89uCWI2;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758059140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oMu80/8qr3zTmEJZAl1KXHqB5S4PD4PrukmUZoG8ms=;
	b=bPlFqemChJuPfOXmZcIvE8PO9yQbbLvPZyPv96TMfM3gLYUBpU7FJyqWFP00+IL/CykhqC
	TCHb6kXTKG0CgBn1yNarJG4Sty83cPet3erOUB1jeHzfWIVsR03fE0LU5JwMc059vYBOAZ
	txCnfRyNYB0EKAlFrvHWcXTiTyIjVfU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=U89uCWI2;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758059140; a=rsa-sha256;
	cv=none;
	b=cHVbzLv5hzEx1wshYXcbsn2hB10VKCQWPucCE9QEzo8yeT7FWP2nRo8qN4q3aDMTAIJfCE
	T6/wm7fA16LoqKpWhHcvIWqpatZSw+YU5gfWnJ4+bkiat7WmUG5pHK5E1202/UlnG+UWqj
	wJW13OEQHSSbmdjS/z/HyjEQgEw1dyI=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b54acc8c96eso4219475a12.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758059139; x=1758663939; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2oMu80/8qr3zTmEJZAl1KXHqB5S4PD4PrukmUZoG8ms=;
        b=U89uCWI2p0LE99Gr7GJVHPe77qKo7NLiEURtVApbwyspVc4XTOmsIEfVakyPMYj0pc
         PLkL97IsnqKewKJaYqIe8ysMH8hBt5125Wh+1HT1Q8dAmZjjqJbXpB6B7KgDBwqFqEdU
         +TJWA2Wv5vwndMjhXsr3IBU1hvHCUw2McCJNBAbEZL56YACe0AsrmVFSY6CJ/xtVjQN6
         Cw3IYP46qXqzImfzwZSp9G9ANLAyy3bdwNH/go3AJ1UW18f9Azl8rCrhp9lllPdVdJaD
         Vf7cGbPvUjrUkVynDn+m9xVYVC3AHT4eSI+0vWOnMMUZJBqWQYQ2kiDQYOwKVU97AaOi
         aKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758059139; x=1758663939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oMu80/8qr3zTmEJZAl1KXHqB5S4PD4PrukmUZoG8ms=;
        b=IuMHXVxm+NtgDgT2EZodQMmAo06KxwK8azUmWdiZfirlFmpAz0zj0ugcGulbrikatx
         0QnHyn3SKXiR9hWoG2O7MdLofkSOqqZJo9cbuYe96Xo9zE55vmWOfObqsUdLzznBNhrK
         EXeJO4ki0UKK/UEf5b+VePqiHqkSlGNOLEJ3Eyue7l2Ou/NtV78sli98clHyL5EVZCtY
         jN44dRoa/2CA4oN0Qo0W6AZzBwcXCr/E0VRNu0hPKx4e+h8VzA4GpHTHm2Afevnt+gfZ
         wzEx4pOa97/4pa2xsDv8aSQ6MlE+W+pT7b0pBxPJg+htDdNkYMsVU4xpTTPP9TAzUtTt
         +yeA==
X-Forwarded-Encrypted: i=1; AJvYcCW7troJDr7etuOokClPqjaimhFSnQSYJj9aN9v44WBOzWghE0EJma1E6pbK/8Pg53Ywc0BcIWdSxw==@kvack.org
X-Gm-Message-State: AOJu0YxeNiHr4lTA9szEjMPQlvze8+tOVyaxauVMz5oeKakDa8bDev2E
	i9Cpf33Wo+LDRsXqO3YY2zmvQZnpIKmj15F9EYoHqcK/nWWmnNXOBzGcVxksqonMhtI=
X-Gm-Gg: ASbGnct20lYzN/TKRzP8bSUTq+pO91WoT7vrRq4dVvMcvcUyr9bphBBRyyqYjS4mI3G
	SnBIOHl3Tb8tJTt3tUA18qSZvyQ8Tr940B8M+n817zvTCKyqzsjXKuIvXGS7zCi6cwKhCl+7E86
	dI9ertGYytb1xA40pjxDs+zS+GAnsAY2BSrs1LR4yH2gUHlK6rNQWSfvAQJWvKGLKDeXPCUpK5H
	cQrqZzFPcmCukH5jJGTeQkfY0RtDxGtDNMbaxb5D0eMalRpbsUPFhB1v0PHNhurZrk6G3gTzAFz
	Hcjua8897DXGpXY0jVR4NqSwW3GAoZJYL2RxmuvsN7GuDKut1yrdtaSVmE9TmZbQ+ElI+5UvJSF
	RaPKEGRFAHYkI+zIvO2EzzPIANOoHAJrU
X-Google-Smtp-Source: AGHT+IF5/A9g/gHD57+H8Ivg3g3/IAIPeuIqDTP9P2EseS5E1C+rm4rMi/1Yy80FsS4n3Id30lQozg==
X-Received: by 2002:a17:903:1ab0:b0:24c:d08e:309b with SMTP id d9443c01a7336-25d24cac50fmr187714865ad.15.1758059138768;
        Tue, 16 Sep 2025 14:45:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed266eed7sm530003a91.3.2025.09.16.14.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 14:45:38 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:45:35 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V12 4/5] riscv: mm: Add soft-dirty page tracking support
Message-ID: <aMnaf_3tInUXbuTb@debug.ba.rivosinc.com>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-5-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250915101343.1449546-5-zhangchunyan@iscas.ac.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F392B100009
X-Stat-Signature: coxbpqrnwwu9dphbefx3bgfrw4pwryc3
X-HE-Tag: 1758059139-811605
X-HE-Meta: U2FsdGVkX1+IXXNCmQf2uDIf9ZY/Q1nOmJPLKDPspnr3IuAB/JY4mEinmFgidCbldZyK4YzvB5bt+l/Jf2zcTZ22HSjaHkjcSgjTwTQfeJeRZdYyJdXfcpNLBjt5mTSSMX6fX5LN+YxZlphHSG8wMLTxqy2PHoj/+3TKW45uZmWP3qKe6j9XhWSMWNJ0oJ4BMYitnDcBcfMbbLm4RInRgrzZQfDfc1F0C9XkKH6OLjRLUW5rV2U4v0lZfQJ+MsMPR+CC4jpZDcunpKVZ1AcdAOdPfrNMEBgBR1r+2FD6anxMSUIS5t/ZelvU429EI7H21qnEM98PAPfaA4tiXgkbmQJwlVivZh9wWBV8SQi8i9iWYFxi9jWZTYhiQaqJH+f0iAYXdTJRhbGeV8lpkIwjCckmiUe+0h/HLa+1KnlGsQj6k2wOEC8B20X8Rml0mlgjPuNAxkwj1Sq7fylt2vFiPB2i0SF+WBqkefM3Gk8CXtgJbhbQ6HHgfxCXOeAUUc+XcUQHlJ1N6EttwSAiOiUdIKkY8cvL5LquPLOhAMvkfSEE67pnKptopr/uX6ROQkLZFBHkYjeG+MXnIFG+Bzijrja9/H4HF5o84Et7JbOdAA5eaYb6xbALW+yopaca/dr6F1J2FV+Uk1PJiFhnIMTe8xdzocqbwDempSDCaYjV/HC+2Qpds9ntWRtVVEtUl5I9xiQseTXtXvPVD209AlVp+OFN0IvXTaM6v0VR0i/JrNKUPrFDt6ZtzlVq7uMvjHxVGFuRp7wYjZbUMyCKhD2clwB5IT+Q9YrWJrKWl65A3iawdQ/Wfq6PMnPW6r7o6oxcNBNQ6GbRG+qyNTnqYpk+WlSCPpg8Qd6eXlWX6TtszafYm5Nt0jsTr3Jwv5Qt+hnPz/h52fF89LqaW13Ewngcb1P+iPNnC07fRzhDCDBwbchN5YO6cGBRDl+ahuGtfazns8r4lRbKDLrwPhBmz8q
 jzYHlmxl
 e9fkPyrrMjxJbJeeaiTiFNmCWtmK9nsMy1VCbuOrAf0Uq9DDmBM9KTJixSfvRAJtAtWWMPFuJsTSeQ6dPgShBO/gbbUP6r8uOLjj+v3JwzeCd2zVeJw/W+Z+8VeGMC1N4DkmQBInEeXxVooCJ4Rlhq4b2xkwT+sqW1aMR/p+TsCPvtZ/fhoPuqdvEkfxrqymM45BGTjueKtmesRSEw2SFiV3rpw2rFXKl/YzRa90Ay2+9cfnAuql5WHzDW4hyRoQyZDafDaj2YV0QDYmx7TXgqto8ok+xbFn/UzsfdDiePvT2xjW56wMUyc9VjIjKlE64e2+SvE9+yluMGki+FzbXKCd4MRGlnV+U6Hs8ror7svnj0mCNEpYI3gYZKiBFIBLZ/TcG1bP+q6GowKnondJJFArMmSmKMaFVtpTIY8HqO7xTSeXyZaf/koftUzpZ47hzjg42ZkYJ8yObD+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 06:13:42PM +0800, Chunyan Zhang wrote:
>The Svrsw60t59b extension allows to free the PTE reserved bits 60 and 59
>for software, this patch uses bit 59 for soft-dirty.
>
>To add swap PTE soft-dirty tracking, we borrow bit 3 which is available
>for swap PTEs on RISC-V systems.
>
>Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

Reviewed-by: Deepak Gupta <debug@rivosinc.com>
>---

